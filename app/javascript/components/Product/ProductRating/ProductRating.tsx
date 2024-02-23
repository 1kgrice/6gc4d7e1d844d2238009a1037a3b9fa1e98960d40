import React from 'react'
import { Product } from '~/models'

const ProductRating: React.FC<{ product: Product }> = ({ product }) => {
  return (
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
  )
}

export default ProductRating
