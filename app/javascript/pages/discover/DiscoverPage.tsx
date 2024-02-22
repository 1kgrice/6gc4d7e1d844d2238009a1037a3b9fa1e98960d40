import React, { useState, useEffect, Fragment, useMemo, useCallback } from 'react'
import { useParams, useLocation, useNavigate } from 'react-router-dom'
import { DiscoverHeader } from '~/components'
import { Category, Product, Tag } from '~/models'
import * as api from '~/network/api'
import { Helmet } from 'react-helmet'
import { redirectSubdomain } from '~/utils/urlHelper'
import { DiscoverAllContent, DiscoverCategoryContent, DiscoverSearchContent } from './sections'
import { objectsDiffer } from '~/utils/comparisonHelper'
import { routes } from '~/routes/discover'

export default function DiscoverPage() {
  const params = useParams<{ category?: string; '*': string }>()
  const location = useLocation()
  const navigate = useNavigate()
  const pageTitleBase = 'Gumtective Discover'
  const [pageTitle, setPageTitle] = useState(pageTitleBase)

  // Root page (all categories)
  const [categories, setCategories] = useState<Category[]>([])

  // Category overview (3D, Design, etc.)
  const [category, setCategory] = useState<Category>()
  const [hotAndNewProducts, setHotAndNewProducts] = useState<Product[]>([])
  const [loadingHotAndNewProducts, setLoadingHotAndNewProducts] = useState(true)
  const [featuredProducts, setFeaturedProducts] = useState<Product[]>([])
  const [loadingFeaturedProducts, setLoadingFeaturedProducts] = useState(true)
  const [bestSellingProducts, setBestSellingProducts] = useState<Product[]>([])
  const [loadingBestSellingProducts, setLoadingBestSellingProducts] = useState(true)
  const [topPwywProducts, setTopPwywProducts] = useState<Product[]>([])
  const [loadingTopPwywProducts, setLoadingTopPwywProducts] = useState(true)
  // const [showcaseProducts, setShowcaseProducts] = useState<Product[]>([])
  // const [loadingShowcaseProducts, setLoadingShowcaseProducts] = useState(true)

  // Product search
  const [searchQuery, setSearchQuery] = useState<{}>({})
  const [discoverProducts, setDiscoverProducts] = useState<Product[]>([])
  const [loadingDiscoverProducts, setLoadingDiscoverProducts] = useState(false)
  const [startedLoadingDiscoverProducts, setStartedLoadingDiscoverProducts] = useState(false)
  const [discoverTags, setDiscoverTags] = useState<Tag[]>([])
  const [discoverableTotal, setDiscoverableTotal] = useState<number>(0)

  const atRoot = useMemo(() => {
    return Object.keys(params).length === 0 || location.pathname === '/'
  }, [location.pathname, params])

  const discoverView = useMemo(() => {
    const queryParams = new URLSearchParams(location.search)
    return !!queryParams.get('sort') || !!queryParams.get('query')
  }, [location.search])

  // Remove tags filter from URL when navigating to a different category and set default sort
  useEffect(() => {
    if (discoverView) {
      const queryParams = new URLSearchParams(location.search)
      queryParams.delete('tags')
      if (!queryParams.has('sort')) {
        queryParams.set('sort', 'default')
      }
      navigate(`?${queryParams.toString()}`, { replace: true })
    }
  }, [location.pathname])

  // Fetches staff picked products if at root
  useEffect(() => {
    if (atRoot) {
      fetchRootCategories()
      fetchProductData(
        api.getStaffPickedProducts,
        {},
        setFeaturedProducts,
        setLoadingFeaturedProducts,
        { clearData: true }
      )
      // fetchProductData(
      //   api.getShowcaseProducts,
      //   {},
      //   setShowcaseProducts,
      //   setLoadingShowcaseProducts,
      //   {
      //     clearData: true
      //   }
      // )
    }
  }, [atRoot])

  // Set the discover view based on query parameters, fetch initial product batch of products
  useEffect(() => {
    fetchAllProducts()
  }, [location.search, location.pathname])

  // Infinite scrolling functionality for search
  const handleScroll = useCallback(async () => {
    const bottom =
      Math.ceil(window.innerHeight + window.scrollY) >= document.documentElement.scrollHeight
    if (bottom && discoverView && !loadingDiscoverProducts) {
      fetchMoreDiscoverProducts()
    }
  }, [loadingDiscoverProducts, discoverView])

  // Event listener for scroll events to support infinite scrolling
  useEffect(() => {
    window.addEventListener('scroll', handleScroll)
    return () => window.removeEventListener('scroll', handleScroll)
  }, [handleScroll])

  // Fetch root categories from the API (3D, Design, etc.)
  const fetchRootCategories = async () => {
    try {
      const resp = await api.getRootCategories()
      const newCategories = resp.categories.map((item) => new Category(item))
      setCategories(newCategories)
    } catch (error) {
      console.error('Error fetching categories:', error)
    }
  }

  // Fetch specific category data
  const fetchCategoryDetails = async () => {
    const longSlug = params['*'] ? `${params['category']}/${params['*']}` : params['category']
    if (!longSlug) return
    try {
      const response = await api.getCategoryByLongSlug({ longSlug })
      setCategory(new Category(response.category))
      setPageTitle(
        `${response.category.ancestors
          .concat(response.category)
          .map((ancestor) => ancestor.name)
          .join(' > ')} | ${pageTitleBase}`
      )
    } catch (error) {
      navigate(routes.notFound, { replace: true })
      console.error('Error fetching category:', error)
    }
  }

  const constructFilterQuery = (queryParams, longSlug = '', offset = 0) => {
    return {
      category: longSlug,
      from: offset,
      ...(queryParams.get('query') && { query: queryParams.get('query') }),
      ...(queryParams.get('sort') && { sort: queryParams.get('sort') }),
      ...(queryParams.get('min_price') && {
        min_price: parseInt(queryParams.get('min_price') ?? '', 10) * 100
      }),
      ...(queryParams.get('max_price') && {
        max_price: parseInt(queryParams.get('max_price') ?? '', 10) * 100
      }),
      ...(queryParams.get('pwyw') && { pwyw: queryParams.get('pwyw') }),
      ...(queryParams.get('rating') && { rating: queryParams.get('rating') }),
      ...(queryParams.get('tags') && { tags: queryParams.get('tags') })
    }
  }

  const fetchAllProducts = async () => {
    const longSlug = location.pathname.replace(/^\//, '')
    const queryParams = new URLSearchParams(location.search)
    const discoverView = !!queryParams.get('sort') || !!queryParams.get('query')

    if (discoverView) {
      const filterQuery = constructFilterQuery(queryParams, longSlug, 0)
      fetchProductData(
        api.getProductsFromSearch,
        filterQuery,
        setDiscoverProducts,
        setLoadingDiscoverProducts,
        { clearTags: true, clearData: true, saveQuery: true }
      )
    } else {
      // Fetch hotAndNewProducts, featuredProducts, bestSellingProducts outside of discoverView
      fetchProductData(
        api.getHotAndNewProducts,
        { category: longSlug },
        setHotAndNewProducts,
        setLoadingHotAndNewProducts,
        { clearData: true }
      )
      fetchProductData(
        api.getStaffPickedProducts,
        { category: longSlug },
        setFeaturedProducts,
        setLoadingFeaturedProducts,
        { clearData: true }
      )
      fetchProductData(
        api.getBestSellingProducts,
        { category: longSlug },
        setBestSellingProducts,
        setLoadingBestSellingProducts,
        { clearData: true }
      )
      fetchProductData(
        api.getTopPwywProducts,
        { category: longSlug },
        setTopPwywProducts,
        setLoadingTopPwywProducts,
        { clearData: true }
      )
    }
  }

  const fetchMoreDiscoverProducts = async () => {
    if (discoverProducts.length < 9) {
      return
    }
    const longSlug = location.pathname.replace(/^\//, '')
    const queryParams = new URLSearchParams(location.search)
    const filterQuery = constructFilterQuery(queryParams, longSlug, discoverProducts.length)

    let newQuery = { ...filterQuery }
    let prevQuery = { ...searchQuery }
    delete prevQuery['from']
    delete newQuery['from']

    fetchProductData(
      api.getProductsFromSearch,
      filterQuery,
      (newProducts) => {
        setDiscoverProducts((prevProducts) => {
          let products = [...prevProducts, ...newProducts]
          return products
        })
      },
      setLoadingDiscoverProducts,
      { clearTags: objectsDiffer(newQuery, prevQuery), saveQuery: true }
    )
  }

  const fetchProductData = async (
    apiMethod,
    queryParams,
    setState,
    setLoading,
    options: { clearData?: boolean; clearTags?: boolean; saveQuery?: boolean } = {
      clearData: false,
      clearTags: false,
      saveQuery: false
    }
  ) => {
    if (options.clearData) {
      setState([])
    }
    if (options.clearTags) {
      setDiscoverTags([])
    }
    if (options.saveQuery) {
      setSearchQuery(queryParams)
    }
    if (setState == setDiscoverProducts) {
      setStartedLoadingDiscoverProducts(true)
    }
    setLoading(true)
    try {
      const response = await apiMethod(queryParams)
      const products = response.products.map((product) => new Product(product))
      setState(products)
      setDiscoverableTotal(response.total)
      if (response.top_tags) {
        const tags = response.top_tags.map((tag) => new Tag(tag))
        setDiscoverTags(tags)
      }
    } catch (error) {
      console.error(`Error fetching products:`, error)
    } finally {
      setLoading(false)
    }
  }

  // Redirects to the 'discover' subdomain and fetches category data
  useEffect(() => {
    redirectSubdomain('discover')
    if (!atRoot) {
      fetchCategoryDetails()
    }
  }, [params.category, params['*'], atRoot])

  useEffect(() => {
    fetchAllProducts()
  }, [location.search, location.pathname, discoverView])

  return (
    <Fragment>
      <Helmet>
        <title>{pageTitle}</title>
      </Helmet>
      <main style={{ minHeight: '100vh', display: 'grid', gridTemplateRows: 'auto 1fr auto' }}>
        <DiscoverHeader />
        {atRoot && !discoverView && (
          <DiscoverAllContent
            categories={categories}
            featuredProducts={featuredProducts}
            loadingFeaturedProducts={loadingFeaturedProducts}
          />
        )}
        {discoverView && (
          <DiscoverSearchContent
            category={category}
            discoverTags={discoverTags}
            discoverProducts={discoverProducts}
            discoverableTotal={discoverableTotal}
            loadingDiscoverProducts={loadingDiscoverProducts}
            startedLoadingDiscoverProducts={startedLoadingDiscoverProducts}
          />
        )}
        {!discoverView && params.category && (
          <DiscoverCategoryContent
            featuredProducts={featuredProducts}
            hotAndNewProducts={hotAndNewProducts}
            bestSellingProducts={bestSellingProducts}
            topPwywProducts={topPwywProducts}
            loadingFeaturedProducts={loadingFeaturedProducts}
            loadingHotAndNewProducts={loadingHotAndNewProducts}
            loadingBestSellingProducts={loadingBestSellingProducts}
            loadingTopPwywProducts={loadingTopPwywProducts}
          />
        )}
      </main>
    </Fragment>
  )
}
