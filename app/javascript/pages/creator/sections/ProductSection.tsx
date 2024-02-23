import React, { useState, Fragment, useMemo } from 'react'
import { Link } from 'react-router-dom'
import {
  SkeletonContainer,
  Carousel,
  RatingSection,
  ProductOptionsSection,
  ProductRating
} from '~/components'
import { gCircleAltPink } from '~/assets/images'
import { Product } from '~/models'
import { Img } from 'react-image'
import Skeleton from 'react-loading-skeleton'
import { formatPrice } from '~/utils/currencyHelper'

interface ProductSectionProps {
  product?: Product
  cartButtonCallback?: (event: React.MouseEvent<HTMLAnchorElement, MouseEvent>) => void
}

const ProductSection: React.FC<ProductSectionProps> = ({ product, cartButtonCallback }) => {
  const [productValue, setProductValue] = useState('')
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value
    const numericValue = newValue.replace(/[^\d]/g, '')
    setProductValue(numericValue)
  }

  const formattedPrice = useMemo(
    () => formatPrice(product?.price || 0, product?.currency || 'USD', false),
    [product]
  )

  const getButtonText = (product: Product | undefined) => {
    if (!product) return 'Add to cart'
    const optionMap: { [key: string]: string } = {
      i_want_this_prompt: 'I want this!',
      buy_this_prompt: 'Buy this',
      pay_prompt: 'Pay'
    }

    return (
      product.customViewContentButtonText ||
      optionMap[product.customButtonTextOption] ||
      'Add to cart'
    )
  }

  if (!product) {
    return (
      <SkeletonContainer>
        <Skeleton width={2000} height={2000} />
      </SkeletonContainer>
    )
  }

  {
    // Sales section
    /* {productsalesCount > 0 && (
        <div role="status" className="info">
          <span>
            <strong>{productsalesCount}</strong>{' '}
            {productsalesCount === 1 ? 'sale' : 'sales'}
          </span>
        </div>
      )} */
  }

  return (
    <div>
      {/* Main Product */}
      <section style={{ position: 'relative' }}>
        <article className="product">
          <Carousel items={product.carouselItems} />
          <section>
            <header>
              <h1 itemProp="name" id="product-title">
                {product.name}
              </h1>
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
                    <div className="price" itemProp="price" content={product.price.toString()}>
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
                    src={[product.creator.avatarUrl, gCircleAltPink]}
                    alt={product.creator.name}
                  />
                  {product.creator.name}
                </Link>
              </div>
              <ProductRating product={product} />
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
            <section>
              {product.options.length > 0 && (
                <section>
                  <ProductOptionsSection product={product} />
                </section>
              )}
              {product.isPwyw && (
                <fieldset>
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
                onClick={cartButtonCallback}
                style={{ alignItems: 'unset' }}
              >
                {getButtonText(product)}
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
    </div>
  )
}

export default ProductSection
