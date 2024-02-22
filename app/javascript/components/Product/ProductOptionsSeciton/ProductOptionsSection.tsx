import React, { useState } from 'react'
import { ProductOption } from '~/models'
import { formatPrice } from '~/utils/currencyHelper'
// const formatPrice = (priceCents, isPwyw = false) => {
//   let price = (priceCents / 100).toFixed(2)
//   price = price.endsWith('.00') ? Number(price).toFixed(0) : price
//   return `$${price}` + (isPwyw ? '+' : '')
// }

const ProductOptionsSection = ({ product }) => {
  // State to keep track of the selected option index
  const [selectedOptionIndex, setSelectedOptionIndex] = useState(0)

  const lowestPrice = product.options.reduce(
    (min, option) => Math.min(min, option.priceDifferenceCents),
    product.options[0].priceDifferenceCents
  )

  const handleOptionSelect = (index) => {
    setSelectedOptionIndex(index)
  }

  return (
    <div
      className="radio-buttons"
      role="radiogroup"
      itemProp="offers"
      itemType="https://schema.org/AggregateOffer"
      itemScope
    >
      {product.options.map((option, index) => (
        <button
          key={index}
          role="radio"
          aria-checked={selectedOptionIndex === index}
          aria-label={option.name}
          itemProp="offer"
          itemType="https://schema.org/Offer"
          itemScope
          onClick={() => handleOptionSelect(index)} // Update selection on click
          className={selectedOptionIndex === index ? 'selected' : ''} // Apply 'selected' class to the selected option
        >
          <div className="pill">
            {option.isPwyw
              ? 'Pay What You Want'
              : formatPrice(
                  product.price + option.priceDifferenceCents,
                  product.currency,
                  false,
                  2,
                  option.isPwyw
                )}
            <div itemProp="price" hidden>
              {option.priceDifferenceCents / 100}
            </div>
            <div itemProp="priceCurrency" hidden>
              USD
            </div>
          </div>
          <div>
            <h4>{option.name}</h4>
            <div>{option.description}</div>
          </div>
        </button>
      ))}
      {/* <div itemProp="offerCount" hidden>
        {product.options.length}
      </div>
      <div itemProp="lowPrice" hidden>
        {lowestPrice / 100}
      </div>
      <div itemProp="priceCurrency" hidden>
        USD
      </div> */}
    </div>
  )
}

export default ProductOptionsSection
