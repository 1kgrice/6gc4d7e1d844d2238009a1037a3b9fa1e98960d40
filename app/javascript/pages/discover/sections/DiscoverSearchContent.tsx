import React, { useMemo } from 'react'
import { ProductFilterGroup, Card } from '~/components'
import { useLocation } from 'react-router-dom'
import { Category, Product, Tag } from '~/models'
import { SkeletonCard } from '~/components'

interface DiscoverSearchContent {
  category?: Category
  discoverTags: Tag[]
  discoverProducts: Product[]
  discoverableTotal: number
  loadingDiscoverProducts: boolean
  startedLoadingDiscoverProducts: boolean
}

const DiscoverSearchContent: React.FC<DiscoverSearchContent> = ({
  category,
  discoverTags,
  discoverProducts,
  discoverableTotal,
  loadingDiscoverProducts,
  startedLoadingDiscoverProducts
}) => {
  const location = useLocation()

  const queryContent = useMemo(() => {
    const queryParams = new URLSearchParams(location.search)

    return queryParams.get('query') || ''
  }, [location.search])
  return (
    <div className="with-sidebar">
      <ProductFilterGroup
        category={category}
        products={discoverProducts}
        tags={discoverTags}
        productTotal={discoverableTotal}
        loading={loadingDiscoverProducts}
        filters={{
          category: true,
          sort: true,
          price: true,
          rating: true,
          tags: true,
          pwyw: true
        }}
      />

      {discoverProducts.length > 0 && (
        <div className="product-card-grid">
          {discoverProducts.map((product) => (
            <Card
              highlightSubstring={queryContent}
              key={`discover-product-${product.permalink}-${product.id}`}
              product={product}
            />
          ))}
          {loadingDiscoverProducts &&
            Array.from({ length: 3 }, (_, index) => <SkeletonCard key={`skeleton-${index}`} />)}
        </div>
      )}

      {!loadingDiscoverProducts && discoverProducts.length == 0 && (
        <div
          className="paragraphs"
          style={{ textAlign: 'center', height: '100%', alignContent: 'center' }}
        >
          <h1 className="text-muted">
            <span className="icon icon-archive-fill"></span>
          </h1>
          No products found
        </div>
      )}
      {loadingDiscoverProducts && discoverProducts.length == 0 && (
        <div className="product-card-grid">
          {loadingDiscoverProducts &&
            Array.from({ length: 3 }, (_, index) => <SkeletonCard key={`skeleton-${index}`} />)}
        </div>
      )}
    </div>
  )
}

export default DiscoverSearchContent
