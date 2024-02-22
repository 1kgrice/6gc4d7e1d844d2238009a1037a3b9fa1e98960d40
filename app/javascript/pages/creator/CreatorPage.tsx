import React, { useState, useEffect, Fragment, useCallback } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { Helmet } from 'react-helmet'
import { DiscoverHeader, Card, SkeletonCard } from '~/components'
import { gumtectiveBlack } from '~/assets/images'
import { Product, Creator } from '~/models'
import * as api from '~/network/api'
import { Img } from 'react-image'
import { routes } from '~/routes/discover'

const CreatorPage = () => {
  const [creator, setCreator] = useState<Creator | null>(null)
  const [products, setProducts] = useState<Product[]>([])
  const [loadingProducts, setLoadingProducts] = useState<boolean>(false)
  const navigate = useNavigate()
  const hostname = window.location.hostname
  const username = hostname.split('.')[0]
  const location = useLocation()

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

  useEffect(() => {
    document.body.classList.add('lightTheme')

    const fetchCreator = async () => {
      try {
        const { creator: fetchedCreator } = await api.getCreator({
          username: username
        })
        setCreator(new Creator(fetchedCreator))
      } catch (err) {
        navigate('/404', { replace: true })
        console.error(err)
      }
    }

    fetchCreator()
  }, [location])

  const fetchMoreProducts = async () => {
    if (!creator) return

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
      setLoadingProducts
    )
  }

  // Infinite scrolling functionality for search
  const handleScroll = useCallback(async () => {
    const bottom =
      Math.ceil(window.innerHeight + window.scrollY) >= document.documentElement.scrollHeight
    if (bottom && !loadingProducts) {
      fetchMoreProducts()
    }
  }, [loadingProducts])

  useEffect(() => {
    window.addEventListener('scroll', handleScroll)
    return () => window.removeEventListener('scroll', handleScroll)
  }, [handleScroll])

  useEffect(() => {
    if (!creator) return
    fetchProductData(
      api.getProductsFromSearch,
      { creator: creator.username, from: products.length },
      setProducts,
      setLoadingProducts
    )
  }, [creator])

  return (
    <Fragment>
      <Helmet>
        <title>{username}</title>
        {creator && <link rel="icon" type="image/png" href={creator.avatarUrl} />}
      </Helmet>
      {creator && (
        <Fragment>
          <DiscoverHeader showNav={false} creatorMode creator={creator} />
          {creator.bio && (
            <div>
              <h1 className="whitespace-pre-line">{creator.bio}</h1>
            </div>
          )}
          <main>
            <section className="grid relatve" style={{ gap: 'var(--spacer-6)' }}>
              <div className="with-sidebar">
                {products.length > 0 && (
                  <div className="product-card-grid">
                    {products.map((product) => (
                      <Card
                        key={`discover-product-${product.permalink}-${product.id}`}
                        product={product}
                        relativeUrl
                      />
                    ))}
                    {loadingProducts &&
                      Array.from({ length: 3 }, (_, index) => (
                        <SkeletonCard key={`skeleton-${index}`} />
                      ))}
                  </div>
                )}
                {loadingProducts && products.length == 0 && (
                  <div className="product-card-grid">
                    {loadingProducts &&
                      Array.from({ length: 3 }, (_, index) => (
                        <SkeletonCard key={`skeleton-${index}`} />
                      ))}
                  </div>
                )}
              </div>
            </section>
            <footer className="flex !justify-center items-center h-20">
              {/* <a href="https://gumroad.com" className="flex items-center">
                  <span className="logo-full"></span>
                </a>
                <span className="mx-2 icon icon-solid-x"></span> */}
              <a href={routes.homeAbsolute} className="flex items-center">
                <Img src={gumtectiveBlack} style={{ width: 120 }} />
              </a>
            </footer>
          </main>
        </Fragment>
      )}
    </Fragment>
  )
}

export default CreatorPage
