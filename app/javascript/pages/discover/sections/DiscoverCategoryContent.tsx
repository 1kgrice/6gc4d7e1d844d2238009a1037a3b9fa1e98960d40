import React from 'react'
import { CardGroup } from '~/components'
import { Product } from '~/models'
import { TagPillBar } from '~/components'

interface DiscoverCategoryContent {
  featuredProducts: Product[]
  hotAndNewProducts: Product[]
  bestSellingProducts: Product[]
  topPwywProducts: Product[]
  loadingFeaturedProducts: boolean
  loadingHotAndNewProducts: boolean
  loadingBestSellingProducts: boolean
  loadingTopPwywProducts: boolean
}

const DiscoverCaregoryContent: React.FC<DiscoverCategoryContent> = ({
  featuredProducts,
  hotAndNewProducts,
  bestSellingProducts,
  topPwywProducts,
  loadingFeaturedProducts,
  loadingHotAndNewProducts,
  loadingBestSellingProducts,
  loadingTopPwywProducts
}) => {
  return (
    <div className="grid" style={{ gap: 'var(--spacer-6)' }}>
      <TagPillBar />
      <CardGroup
        id="featured-products"
        title="Staff Picks"
        content={featuredProducts}
        show_button={false}
        url="?sort=featured"
        narrow
        length={5}
        loading={loadingFeaturedProducts}
      />
      <CardGroup
        id="hot-and-new-products"
        title="Hot and New"
        content={hotAndNewProducts}
        show_button={true}
        url="?sort=hot_and_new"
        length={3}
        loading={loadingHotAndNewProducts}
      />
      <CardGroup
        id="pwyw-products"
        title="Pay What You Want"
        content={topPwywProducts}
        show_button={true}
        url="?sort=most_reviewed&pwyw=true"
        length={3}
        loading={loadingTopPwywProducts}
      />
      <CardGroup
        id="best-selling-products"
        title="Best Selling"
        content={bestSellingProducts}
        show_button={true}
        url="?sort=best_selling"
        length={3}
        loading={loadingBestSellingProducts}
      />
    </div>
  )
}

export default DiscoverCaregoryContent
