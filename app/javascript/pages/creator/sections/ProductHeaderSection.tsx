import React, { useMemo, useState, useEffect } from 'react'
import { Product } from '~/models'
import { formatPrice } from '~/utils/currencyHelper'
import { ProductRating } from '~/components'
import clsx from 'clsx'
import { getButtonText } from '~/utils/productHelper'

interface ProductHeaderSectionProps {
  product?: Product
  cartButtonCallback?: (event: React.MouseEvent<HTMLAnchorElement, MouseEvent>) => void
}

const ProductHeaderSection: React.FC<ProductHeaderSectionProps> = ({
  product,
  cartButtonCallback
}) => {
  const [isVisible, setIsVisible] = useState(true)

  const formattedPrice = useMemo(
    () => formatPrice(product?.price || 0, product?.currency || 'USD', false),
    [product]
  )

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        setIsVisible(!entry.isIntersecting)
      },
      {
        root: null,
        threshold: 0.1
      }
    )

    const target = document.querySelector('#product-title')
    if (target) {
      observer.observe(target)
    }

    return () => {
      if (target) {
        observer.unobserve(target)
      }
    }
  }, [])

  if (!product) return <></>

  return (
    <section
      aria-label="Product information bar"
      style={{
        overflow: 'hidden',
        padding: 0,
        border: 'medium',
        height: 82,
        transition: 'var(--transition-duration)',
        flexShrink: 0,
        order: -1,
        position: 'sticky',
        top: 0,
        zIndex: 'var(--z-index-menubar)',
        boxShadow: `0 var(--border-width) rgb(var(--color)), 0 calc(-1 * var(--border-width)) rgb(var(--color))`
      }}
      className={clsx(
        'hidden md:block',
        'transition-opacity duration-200',
        { 'opacity-100': isVisible },
        { 'opacity-0': !isVisible },
        { invisible: !isVisible },
        { visible: isVisible }
      )}
    >
      <div className="product-cta" style={{ transition: 'var(--transition-duration)' }}>
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
        <h3>{product.name}</h3>
        <ProductRating product={product} />
        <a
          className="accent button"
          onClick={cartButtonCallback}
          target="_top"
          href={product.url}
          style={{ alignItems: 'unset' }}
        >
          {getButtonText(product)}
        </a>
      </div>
    </section>
  )
}

export default ProductHeaderSection
