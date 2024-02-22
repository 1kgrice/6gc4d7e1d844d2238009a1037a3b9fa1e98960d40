import React, { useMemo } from 'react'
import Skeleton from 'react-loading-skeleton'
import { SkeletonContainer } from '~/components'

const SkeletonCard = () => {
  return (
    <SkeletonContainer>
      <article className="product-card pointer-events-none" style={{ border: 'none' }}>
        <div className="carousel" style={{ border: 'none', background: 'none' }}>
          <div className="items">
            <Skeleton height="100%" width="100%" />
          </div>
        </div>
      </article>
    </SkeletonContainer>
  )
}

export default SkeletonCard
