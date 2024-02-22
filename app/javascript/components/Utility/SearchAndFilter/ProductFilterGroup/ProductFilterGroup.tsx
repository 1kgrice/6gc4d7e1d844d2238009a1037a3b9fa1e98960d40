import React, { useCallback, useEffect, useState, useMemo } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import clsx from 'clsx'
import {
  FilterCategory,
  PwywFilter,
  PriceFilter,
  RatingFilter,
  SortSelect,
  TagFilter
} from '~/components'
import { Category, Product, Tag } from '~/models'
import { useViewportIsAbove } from '~/utils/viewportHelper'
import './ProductFilterGroup.scss'

interface ProductFilterGroupProps {
  category?: Category
  products?: Product[]
  tags?: Tag[]
  productTotal: number
  loading?: boolean
  filters: {
    category?: boolean
    sort?: boolean
    price?: boolean
    rating?: boolean
    tags?: boolean
    pwyw?: boolean
  }
}

const ProductFilterGroup: React.FC<ProductFilterGroupProps> = ({
  products = [],
  tags = [],
  productTotal,
  loading,
  filters
}) => {
  const isAboveMdViewport = useViewportIsAbove('md')
  const [isFiltersVisible, setIsFiltersVisible] = useState(false)
  const navigate = useNavigate()
  const location = useLocation()

  // Adjust visibility based on viewport size
  useEffect(() => {
    setIsFiltersVisible(isAboveMdViewport)
  }, [isAboveMdViewport])

  const toggleFiltersVisibility = useCallback(() => {
    setIsFiltersVisible((isVisible) => !isVisible)
  }, [])

  const handleClear = useCallback(() => {
    navigate('?sort=default')
  }, [navigate])

  const shouldShowClear = useMemo(() => {
    const searchParams = new URLSearchParams(location.search)
    return !(
      searchParams.toString() === '' ||
      (searchParams.toString() === 'sort=default' && searchParams.get('sort') === 'default')
    )
  }, [location.search])

  const displayProductCount = useMemo(() => {
    if (loading) return 'Loading...'
    return products.length > 0
      ? `Showing 1-${products.length} of ${productTotal} products`
      : 'No products found'
  }, [loading, products.length, productTotal])

  return (
    <div className="stack" aria-label="Filters">
      <header>
        <div>{displayProductCount}</div>
        {shouldShowClear && (
          <div>
            <a role="button" className="cursor-pointer" onClick={handleClear}>
              Clear
            </a>
          </div>
        )}
        <div className={clsx({ hidden: isAboveMdViewport })}>
          <a role="button" className="cursor-pointer" onClick={toggleFiltersVisibility}>
            Filter
          </a>
        </div>
      </header>
      {isFiltersVisible && (
        <>
          {filters.category && <FilterCategory />}
          {filters.sort && <SortSelect />}
          {filters.price && <PriceFilter />}
          {filters.pwyw && <PwywFilter />}
          {filters.rating && <RatingFilter />}
          {filters.tags && <TagFilter tags={tags} loading={loading} />}
        </>
      )}
    </div>
  )
}

export default ProductFilterGroup
