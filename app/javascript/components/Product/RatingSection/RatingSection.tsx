import React from 'react'
import { Product } from '~/models'

interface RatingsProps {
  product: Product
}

const RatingsSection: React.FC<RatingsProps> = ({ product }) => {
  const { count, average } = product.ratings
  const totalRatings = product.getRatingCount()
  const percentage = (star: number) => {
    if (totalRatings === 0) return 0
    return (count[star - 1] / totalRatings) * 100
  }

  return (
    <section>
      <header>
        <h3>Ratings</h3>
        <div className="rating">
          <span className="icon icon-solid-star"></span>
          <div className="rating-average">{average.toFixed(1)}</div>({totalRatings} ratings)
        </div>
      </header>
      <div
        itemProp="aggregateRating"
        itemType="https://schema.org/AggregateRating"
        itemScope
        hidden
      >
        <div itemProp="reviewCount">{totalRatings}</div>
        <div itemProp="ratingValue">{average}</div>
      </div>
      <section className="histogram" aria-label="Ratings histogram">
        {count
          .map((starCount, index) => {
            const starRating = index + 1
            return (
              <React.Fragment key={starRating}>
                <div>{starRating} stars</div>
                <meter
                  aria-label={`${starRating} stars`}
                  value={starCount}
                  max={totalRatings || 1}
                ></meter>
                <div>{percentage(starRating).toFixed(0)}%</div>
              </React.Fragment>
            )
          })
          .reverse()}
      </section>
    </section>
  )
}

export default RatingsSection
