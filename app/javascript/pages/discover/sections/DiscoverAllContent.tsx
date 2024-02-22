import React, { Fragment } from 'react'
import { CardGroup, CategoryList } from '~/components'
import { Category, Product } from '~/models'

interface DiscoverAllContentProps {
  categories: Category[]
  featuredProducts: Product[]
  loadingFeaturedProducts: boolean
}

const DiscoverAllContent: React.FC<DiscoverAllContentProps> = ({
  categories,
  featuredProducts,
  loadingFeaturedProducts
}) => {
  return (
    <Fragment>
      <CardGroup
        id="featured-products"
        title="Staff Picks"
        content={featuredProducts}
        show_button={false}
        narrow
        length={5}
        loading={loadingFeaturedProducts}
      />
      <CategoryList categories={categories} />
    </Fragment>
  )
}

export default DiscoverAllContent
