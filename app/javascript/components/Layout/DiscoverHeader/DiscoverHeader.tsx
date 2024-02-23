import clsx from 'clsx'
import { useTheme } from 'contexts/themeProvider'
import React, { Fragment, useEffect, useMemo, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { gumtectiveBlack, gumtectiveWhite, gCircleAltPink } from '~/assets/images'
import { HamburgerNav, PillNav, ProductSearchBar, PopupWindow } from '~/components'
import { Category, Creator, Product } from '~/models'
import * as api from '~/network/api'
import { ensureLeadingSlash } from '~/utils/urlHelper'
import { routes } from '~/routes/discover'
import './DiscoverHeader.scss'
import { Img } from 'react-image'
import Skeleton from 'react-loading-skeleton'
import { SkeletonContainer } from '~/components'
import { convertToGumroadUrl } from '~/utils/urlHelper'

interface IDiscoverHeader {
  showNav?: boolean
  absoluteUrl?: boolean
  creatorMode?: boolean
  creator?: Creator | null
  navigationCallback?: () => void
}

const DiscoverHeader = ({
  showNav = true,
  absoluteUrl,
  creatorMode,
  creator,
  navigationCallback = () => {}
}: IDiscoverHeader) => {
  const [category, setCategory] = useState<Category | null>(null)
  const { colorTheme } = useTheme()
  const params = useParams()
  const discoverUrl = routes.homeAbsolute || ''
  const [isPopupOpen, setIsPopupOpen] = useState(false)

  const [randomProduct, setRandomProduct] = useState<Product | null>(null)
  const [_, setLoadingRandomProduct] = useState<boolean>(false)

  useEffect(() => {
    new Image().src = gumtectiveWhite
    new Image().src = gumtectiveBlack
  }, [])

  useEffect(() => {
    const fetchCategory = async () => {
      const { category: categoryParam, '*': wildcardParam } = params
      if (categoryParam) {
        const longSlug = wildcardParam ? `${categoryParam}/${wildcardParam}` : categoryParam
        try {
          const { category } = await api.getCategoryByLongSlug({ longSlug })
          setCategory(new Category(category))
        } catch (error) {
          console.error('Error fetching category:', error)
        }
      } else {
        setCategory(null)
      }
    }
    fetchCategory()
  }, [params])

  function adjustProductUrlBasedOnCurrentPageContext(suppliedUrl) {
    const currentPageUrl = window.location.href
    const currentPageUrlObj = new URL(currentPageUrl)
    const suppliedUrlObj = new URL(suppliedUrl)

    const isCurrentPageDiscover = currentPageUrlObj.hostname.startsWith('discover.')

    const isCurrentPageCreator = !currentPageUrlObj.pathname.includes('/l/')
    const isSuppliedUrlProductPage = suppliedUrlObj.pathname.includes('/l/')

    if (isCurrentPageDiscover) {
      return suppliedUrl
    }

    if (isCurrentPageCreator && isSuppliedUrlProductPage) {
      const adjustedUrl = `${suppliedUrlObj.protocol}//${suppliedUrlObj.host}/`
      return adjustedUrl
    }

    return suppliedUrl
  }

  const fetchRandomProduct = async () => {
    try {
      setLoadingRandomProduct(true)
      const response = await api.getProduct({ id: 'random' })
      const product = new Product(response.product)
      setRandomProduct(product)
      setLoadingRandomProduct(false)
      return product
    } catch (error) {
      setLoadingRandomProduct(false)
      console.error('Error fetching category:', error)
    }
  }

  useEffect(() => {
    fetchRandomProduct()
  }, [])

  useEffect(() => {
    const fetchCategory = async () => {
      const { category: categoryParam, '*': wildcardParam } = params
      if (categoryParam) {
        const longSlug = wildcardParam ? `${categoryParam}/${wildcardParam}` : categoryParam
        try {
          const { category } = await api.getCategoryByLongSlug({ longSlug })
          setCategory(new Category(category))
        } catch (error) {
          console.error('Error fetching category:', error)
        }
      } else {
        setCategory(null)
      }
    }
    fetchCategory()
  }, [params])

  const navigateToRandomProduct = async () => {
    if (randomProduct) {
      navigationCallback()
      window.location.href = adjustProductUrlBasedOnCurrentPageContext(randomProduct.url)
    } else {
      const product = await fetchRandomProduct()
      if (product) {
        window.location.href = adjustProductUrlBasedOnCurrentPageContext(product.url)
      }
    }
  }

  const [headerLogo, accentColor] = useMemo(() => {
    const accentColorFromCategory = category?.accentColor
    const accentColorFromAncestors = category?.ancestors?.find(
      (ancestor) => ancestor.accentColor
    )?.accentColor
    const accent = accentColorFromCategory || accentColorFromAncestors
    const headerImage = colorTheme === 'dark' ? gumtectiveWhite : gumtectiveBlack
    return [accent ? gumtectiveBlack : headerImage, accent || null]
  }, [category, colorTheme, params])

  return (
    <Fragment>
      <header className={clsx(accentColor && `bg-${accentColor} text-black`, 'hero')}>
        <>
          {creatorMode ? (
            creator && (
              <Fragment>
                <section>
                  <Link to="/" style={{ textDecoration: 'none' }}>
                    <Img
                      className="user-avatar"
                      src={[creator.avatarUrl, gCircleAltPink]}
                      alt="Profile Picture"
                      loader={
                        <SkeletonContainer className="rounded-full overflow-hidden">
                          <Skeleton height={36} width={36} />
                        </SkeletonContainer>
                      }
                    />
                  </Link>
                  <Link to="/" style={{ textDecoration: 'none' }}>
                    {creator.name}
                  </Link>
                </section>
                <section>
                  <a href={discoverUrl} className="button primary">
                    <span className={'icon icon-search'}></span>
                  </a>
                  <button onClick={navigateToRandomProduct} className="bg-white filled button">
                    <span className="icon icon-button"></span>
                  </button>
                </section>
              </Fragment>
            )
          ) : (
            <div className="hero-actions flex items-center gap-4">
              {absoluteUrl ? (
                <a className="logo shrink-0 w-64" href={discoverUrl}>
                  <img className="h-full" alt="Logo" src={headerLogo} />
                </a>
              ) : (
                <Link className="logo shrink-0 w-64" to="/">
                  <img className="h-full" alt="Logo" src={headerLogo} />
                </Link>
              )}

              <div className="flex flex-grow mt-4 sm:mt-0 gap-4 items-center">
                <div className="flex-grow">
                  <ProductSearchBar />
                </div>
                <button
                  onClick={navigateToRandomProduct}
                  className="shrink-0 bg-white filled button button-primary underline flex items-center space-x-1"
                >
                  <span className="icon icon-button"></span>
                  <span className="hidden xl:inline">I'm feeling lucky</span>
                </button>
                {showNav && (
                  <div className="shrink-0 xl:hidden">
                    <HamburgerNav />
                  </div>
                )}
              </div>
            </div>
          )}
        </>

        {showNav && (
          <Fragment>
            <PillNav />
            <div style={{ display: 'grid', gridColumn: 1 }}>
              <div style={{ gridColumn: 1 }}>
                <div role="navigation" className="breadcrumbs" aria-label="Breadcrumbs">
                  <ol itemScope itemType={'https://schema.org/BreadcrumbList'}>
                    {category?.ancestors.map((ancestor, index) => {
                      return (
                        <li
                          itemProp={'itemListElement'}
                          itemScope
                          itemType={'https://schema.org/ListItem'}
                          key={`ancestor-${index}`}
                        >
                          <Link to={ensureLeadingSlash(ancestor.longSlug)} itemProp={'item'}>
                            <span itemProp={'name'}>{ancestor.name}</span>
                          </Link>
                          <meta itemProp={'position'} content={`${index + 1}`} />
                        </li>
                      )
                    })}
                    {category && (
                      <li
                        itemProp="itemListElement"
                        itemScope
                        itemType="https://schema.org/ListItem"
                      >
                        <Link
                          to={ensureLeadingSlash(category.longSlug)}
                          aria-current="page"
                          itemProp="item"
                        >
                          <span itemProp="name">{category.name}</span>
                        </Link>
                        <meta
                          itemProp="position"
                          content={`${(category.ancestors.length || 0) + 1}`}
                        />
                      </li>
                    )}
                  </ol>
                </div>
              </div>
            </div>
          </Fragment>
        )}
      </header>

      {creator && (
        <PopupWindow
          isOpen={isPopupOpen}
          onClose={() => setIsPopupOpen(false)}
          title="I've a feeling we're not in Kansas anymore..."
          message={`You're about to leave this website. Would you like to see what ${creator.name} has to offer on Gumroad?`}
        >
          <div className="mt-4 flex flex-row space-x-2">
            <a
              href={convertToGumroadUrl(`${creator.profileUrl}`, creator.username)}
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
      )}
    </Fragment>
  )
}

export default DiscoverHeader
