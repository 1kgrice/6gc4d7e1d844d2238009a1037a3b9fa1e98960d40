// Import necessary components and utilities
import React, { useState, useEffect, Fragment, useMemo } from 'react'
import { useParams } from 'react-router-dom'
import { Helmet } from 'react-helmet'
import { DiscoverHeader, Carousel, PopupWindow } from '~/components'
import { Product } from '~/models'
import * as api from '~/network/api'
import { formatPrice } from '~/utils/currencyHelper'
import { convertToGumroadUrl } from '~/utils/urlHelper'
import { RatingSection, ProductOptionsSection } from '~/components'
import { gCircleAltDarkYellow, gumtectiveBlack } from '~/assets/images'
import { Img } from 'react-image'
import { Link, useNavigate } from 'react-router-dom'
import { routes } from '~/routes/discover'

const ProductPage: React.FC = () => {
  const navigate = useNavigate()
  const [product, setProduct] = useState<Product | null>(null)
  const [productValue, setProductValue] = useState('')

  const { permalink } = useParams<{ permalink: string }>()
  const [isPopupOpen, setIsPopupOpen] = useState<boolean>(false)
  const hostname = window.location.hostname
  const username = hostname.split('.')[0]

  const handleChange = (e) => {
    const newValue = e.target.value
    const numericValue = newValue.replace(/[^\d]/g, '')
    setProductValue(numericValue)
  }

  const processCartButtonClick = (event: React.MouseEvent<HTMLAnchorElement, MouseEvent>) => {
    event.preventDefault()
    setIsPopupOpen(true)
  }

  const formattedPrice = useMemo(() => {
    if (!product) return '0'
    return formatPrice(product.price, product.currency, false, 2, product.isPwyw)
  }, [product])

  const gumroadUrl = useMemo(() => {
    if (!product) return '0'
    return convertToGumroadUrl(
      `${product.creator.profileUrl}/l/${product.permalink}`,
      product.creator.username
    )
  }, [product])

  useEffect(() => {
    document.body.classList.add('lightTheme')

    const fetchProduct = async () => {
      try {
        const { product: fetchedProduct } = await api.getCreatorProduct({
          username: username,
          permalink: permalink
        })
        setProduct(new Product(fetchedProduct))
      } catch (err) {
        navigate('/404', { replace: true })
        console.error(err)
      }
    }

    fetchProduct()
  }, [permalink])

  const getButtonText = () => {
    if (!product) return 'Add to cart'
    const optionMap = {
      i_want_this_prompt: 'I want this!',
      buy_this_prompt: 'Buy this',
      pay_prompt: 'Pay'
    }

    if (product.customViewContentButtonText) {
      return product.customViewContentButtonText
    } else if (product.customButtonTextOption && optionMap[product.customButtonTextOption]) {
      return optionMap[product.customButtonTextOption]
    }

    return 'Add to cart'
  }

  return (
    <Fragment>
      <Helmet>
        <title>{product && `${product.name} by ${product.creator.name}`}</title>
        {product && <link rel="icon" type="image/png" href={product.creator.avatarUrl} />}
      </Helmet>
      {product && (
        <Fragment>
          <DiscoverHeader showNav={false} creatorMode creator={product.creator} />
          {product.creator.bio && (
            <div>
              <h1 className="whitespace-pre-line">{product.creator.bio}</h1>
            </div>
          )}
          <main>
            <PopupWindow
              isOpen={isPopupOpen}
              onClose={() => setIsPopupOpen(false)}
              title="You can't make purchases on this website"
              message={`Would you like to check this product on Gumroad?`}
            >
              <div className="mt-4 flex flex-row space-x-2">
                <a
                  href={gumroadUrl}
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

            <section style={{ position: 'relative' }}>
              <article className="product">
                <Carousel items={product.carouselItems} />
                <section>
                  <header>
                    <h1 itemProp="name">{product.name}</h1>
                  </header>
                  <section className="details">
                    {product.options.length == 0 && (
                      <div
                        itemScope
                        itemProp="offers"
                        itemType="https://schema.org/Offer"
                        style={{ display: 'flex', alignItems: 'center' }}
                      >
                        <div className="has-tooltip right" aria-describedby="product-price">
                          <div
                            className="price"
                            itemProp="price"
                            content={product.price.toString()}
                          >
                            {formattedPrice}
                          </div>
                          <div role="tooltip" id="product-price">
                            {formattedPrice}
                          </div>
                        </div>

                        <link itemProp="url" href={product.url} />
                        <div itemProp="availability" hidden>
                          https://schema.org/InStock
                        </div>
                        <div itemProp="priceCurrency" hidden>
                          {product.currency.toUpperCase()}
                        </div>
                      </div>
                    )}
                    <div className="flex items-center" style={{ gap: 'var(--spacer-2)' }}>
                      <Link to="/" className="user relative" rel="noreferrer">
                        <Img
                          className="user-avatar"
                          src={[product.creator.avatarUrl, gCircleAltDarkYellow]}
                          alt={product.creator.name}
                        />
                        {product.creator.name}
                      </Link>
                    </div>
                    <div className="rating">
                      {Array.from({ length: 5 }, (_, index) => {
                        const rating = product.ratings.average
                        let starType = 'icon-outline-star' // Default to outline
                        if (index + 1 <= Math.floor(rating)) {
                          starType = 'icon-solid-star' // Full star
                        } else if (index < Math.ceil(rating) && index + 1 - rating < 1) {
                          starType = 'icon-half-star' // Half star
                        }
                        return <span key={`rn-${index}`} className={`icon ${starType}`}></span>
                      })}
                      <span className="rating-number">
                        {`${product.getRatingCount()} rating${product.getRatingCount() === 1 ? '' : 's'}`}{' '}
                      </span>
                    </div>
                  </section>
                  <section>
                    <div className="rich-text">
                      <div
                        className="tiptap ProseMirror"
                        contentEditable="false"
                        translate="no"
                        dangerouslySetInnerHTML={{ __html: product.descriptionHTML }}
                      ></div>
                    </div>
                  </section>
                </section>
                <section>
                  {product.options.length > 0 && (
                    <section>
                      <ProductOptionsSection product={product} />
                    </section>
                  )}
                  <section>
                    {product.isPwyw && (
                      <fieldset>
                        {product.salesCount > 0 && (
                          <div role="status" className="info">
                            <span>
                              <strong>{product.salesCount}</strong>{' '}
                              {product.salesCount === 1 ? 'sale' : 'sales'}
                            </span>
                          </div>
                        )}
                        <Fragment>
                          <legend>
                            <label>Name a fair price:</label>
                          </legend>
                          <div className="input">
                            <div className="pill">$</div>
                            <input
                              type="text"
                              maxLength={10}
                              placeholder={`${formatPrice(
                                product.pwywSuggestedPrice,
                                product.currency,
                                true
                              )}+`}
                              autoComplete="off"
                              aria-invalid="false"
                              value={productValue}
                              onChange={handleChange}
                            />
                          </div>
                        </Fragment>
                      </fieldset>
                    )}
                    <a
                      className="accent button"
                      target="_top"
                      href="https://gumroad.com/l/9bJZ"
                      onClick={processCartButtonClick}
                      style={{ alignItems: 'unset' }}
                    >
                      {getButtonText()}
                    </a>
                    {product.pAttributes.length > 0 && (
                      <div className="stack">
                        {product.summary && <p>{product.summary}</p>}
                        {product.pAttributes.map((attribute, index) => (
                          <div key={index}>
                            <h5>{attribute.name}</h5>
                            <div>{attribute.value}</div>
                          </div>
                        ))}
                      </div>
                    )}
                  </section>
                  <RatingSection product={product} />
                </section>
              </article>
            </section>
            <footer className="flex !justify-center items-center h-20">
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

export default ProductPage
