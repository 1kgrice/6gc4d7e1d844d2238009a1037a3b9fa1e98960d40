import React, { useEffect } from 'react'
import { Card, SkeletonCard } from '~/components'
import { Product } from '~/models'

interface ProductGridSectionProps {
  loadingCreatorProducts?: boolean
  products: Product[]
}

const ProductGridSection: React.FC<ProductGridSectionProps> = ({
  loadingCreatorProducts = false,
  products = []
}) => {
  useEffect(() => {
    const testScroll = () => console.log('Window scrolled')
    window.addEventListener('scroll', testScroll)
    return () => window.removeEventListener('scroll', testScroll)
  }, [])

  return (
    <section className="grid relative" style={{ gap: 'var(--spacer-6)' }}>
      <div className="with-sidebar">
        {loadingCreatorProducts && products.length == 0 && (
          <div className="product-card-grid">
            {Array.from({ length: 3 }, (_, index) => (
              <SkeletonCard key={`skeleton-${index}`} />
            ))}
          </div>
        )}
        {products.length > 0 && (
          <div className="product-card-grid">
            {products.map((product) => (
              <Card key={product.id} product={product} relativeUrl />
            ))}
            {/* {loadingCreatorProducts &&
              Array.from({ length: 3 }, (_, index) => <SkeletonCard key={`skeleton-${index}`} />)} */}
          </div>
        )}
      </div>
    </section>
  )
}

export default ProductGridSection
