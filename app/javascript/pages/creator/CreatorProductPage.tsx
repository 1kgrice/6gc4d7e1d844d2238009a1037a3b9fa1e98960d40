import React, { useState, useEffect, Fragment, useCallback } from 'react'
import { useLocation, useParams } from 'react-router-dom'
import { Helmet } from 'react-helmet'
import { DiscoverHeader, SkeletonContainer, PopupWindow } from '~/components'
import { gumtectiveBlack } from '~/assets/images'
import { Product, Creator } from '~/models'
import * as api from '~/network/api'
import { Img } from 'react-image'
import { routes } from '~/routes/discover'
import NotFoundPage from '~/pages/common/NotFoundPage'
import Skeleton from 'react-loading-skeleton'
import ProductSection from './sections/ProductSection'
import ProductGridSection from './sections/ProductGridSection'
import ProductHeaderSection from './sections/ProductHeaderSection'
import { convertToGumroadUrl } from '~/utils/urlHelper'

const CreatorProductPage = () => {
  const [creator, setCreator] = useState<Creator | undefined>()
  const [products, setProducts] = useState<Product[]>([])
  const [product, setProduct] = useState<Product | undefined>()
  const [error, setError] = useState<boolean>(false)
  const { permalink } = useParams<{ permalink?: string }>()
  const location = useLocation()
  const hostname = window.location.hostname
  const username = hostname.split('.')[0]

  const loading = !creator
  const [loadingCreatorProducts, setLoadingCreatorProducts] = useState<boolean>(false)
  const [_, setLoadingProduct] = useState<boolean>(false)

  useEffect(() => {
    document.body.classList.add('lightTheme')
  }, [])

  useEffect(() => {
    if (!creator) {
      fetchCreator()
    }
    if (permalink) {
      fetchProduct()
    }
  }, [location, permalink])

  useEffect(() => {
    if (creator && !permalink && products.length === 0) {
      setProduct(undefined)
      fetchProductData(
        api.getProductsFromSearch,
        { creator: creator.username, from: products.length },
        setProducts,
        setLoadingCreatorProducts
      )
    }
  }, [creator, permalink])

  const fetchProductData = async (apiMethod, queryParams, setState, setLoading) => {
    setLoading(true)
    try {
      const response = await apiMethod(queryParams)
      const products = response.products.map((product) => new Product(product))
      setState(products)
      setLoading(false)
    } catch (error) {
      console.error(`Error fetching products:`, error)
    } finally {
      setLoading(false)
    }
  }

  const fetchMoreProducts = async () => {
    if (creator && !permalink) {
      fetchProductData(
        api.getProductsFromSearch,
        {
          creator: creator.username,
          from: products.length
        },
        (newProducts) => {
          setProducts((prevProducts) => {
            let products = [...prevProducts, ...newProducts]
            return products
          })
        },
        setLoadingCreatorProducts
      )
    }
  }

  const handleScroll = useCallback(async () => {
    const bottom =
      Math.ceil(window.innerHeight + window.scrollY) >= document.documentElement.scrollHeight
    console.log('scroll')
    if (bottom && !loadingCreatorProducts) {
      fetchMoreProducts()
    }
  }, [loadingCreatorProducts])

  useEffect(() => {
    window.addEventListener('scroll', handleScroll)
    return () => window.removeEventListener('scroll', handleScroll)
  }, [handleScroll])

  const fetchCreator = async () => {
    try {
      if (!creator) {
        const { creator: fetchedCreator } = await api.getCreator({ username })
        setCreator(new Creator(fetchedCreator))
      }
    } catch (error) {
      setError(true)
      console.error(`Error fetching creator:`, error)
    }
  }

  const fetchProduct = async () => {
    if (!permalink) return
    setLoadingProduct(true)
    try {
      const { product: fetchedProduct } = await api.getCreatorProduct({
        username,
        permalink
      })
      setProduct(new Product(fetchedProduct))
    } catch (error) {
      setError(true)
      console.error(`Error fetching product:`, error)
    } finally {
      setLoadingProduct(false)
    }
  }

  if (error) {
    return <NotFoundPage />
  }

  const [isPopupOpen, setIsPopupOpen] = useState<boolean>(false)

  const processCartButtonClick = (event: React.MouseEvent<HTMLAnchorElement, MouseEvent>) => {
    event.preventDefault()
    setIsPopupOpen(true)
  }

  const gumroadUrl = (product: Product | undefined) => {
    if (!product) return '/'
    return convertToGumroadUrl(
      `${product.creator.profileUrl}/l/${product.permalink}`,
      product.creator.username || ''
    )
  }

  return (
    <Fragment>
      <Helmet>
        <title>{product ? `${product.name} by ${creator?.name}` : creator?.name}</title>
        {creator && <link rel="icon" type="image/png" href={creator.avatarUrl} />}
      </Helmet>
      {creator && (
        <DiscoverHeader
          showNav={false}
          creatorMode
          creator={creator}
          navigationCallback={() => {
            // setCreator(undefined)
            // setProduct(undefined)
          }}
        />
      )}
      <main>
        {permalink && product && (
          <Fragment>
            {product && (
              <ProductHeaderSection product={product} cartButtonCallback={processCartButtonClick} />
            )}
            <PopupWindow
              isOpen={isPopupOpen}
              onClose={() => setIsPopupOpen(false)}
              title="You can't make purchases on this website"
              message={`Would you like to check this product on Gumroad?`}
            >
              <div className="mt-4 flex flex-row space-x-2">
                <a
                  href={gumroadUrl(product)}
                  className="accent button block w-full bg-pink text-black py-2 px-4 rounded text-center"
                >
                  Take me to Gumroad
                </a>
                <button
                  onClick={() => setIsPopupOpen(false)}
                  className="filled button w-full block py-2 px-4 rounded text-center"
                >
                  I'll stay here for now
                </button>
              </div>
            </PopupWindow>
          </Fragment>
        )}
        {loading ? (
          <SkeletonContainer>
            <Skeleton width={2000} height={2000} />
          </SkeletonContainer>
        ) : permalink ? (
          <ProductSection product={product} cartButtonCallback={processCartButtonClick} />
        ) : (
          <ProductGridSection products={products} loadingCreatorProducts={loadingCreatorProducts} />
        )}
        <footer className="flex !justify-center items-center h-20">
          <a href={routes.homeAbsolute} className="flex items-center">
            <Img src={gumtectiveBlack} style={{ width: 120 }} />
          </a>
        </footer>
      </main>
    </Fragment>
  )
}

export default CreatorProductPage
