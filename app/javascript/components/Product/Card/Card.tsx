import React from 'react'
import { Carousel } from '~/components'
import { Product } from '~/models'
import { formatPrice } from '~/utils/currencyHelper'
import { Link } from 'react-router-dom'

export interface ICard {
  id: number
  url: string
  title: string
  carouselItems: string[]
  rating: number
  reviewCount: number
  creator: {
    url: string
    thumbnail: string
    name: string
  }
  priceCents: number
  isPriceFlexible: boolean
  currency: string
  highlightSubstring?: string
  relativeUrl?: boolean
}

const CardFromProduct: React.FC<{
  product: Product
  highlightSubstring?: string
  relativeUrl?: boolean
}> = ({ product, highlightSubstring, relativeUrl }) => {
  const cardProps: ICard = {
    id: product.id,
    url: product.url,
    title: product.name,
    carouselItems: product.carouselItems,
    rating: product.ratings.average,
    reviewCount: product.getRatingCount(),
    creator: {
      url: product.creator.profileUrl,
      thumbnail: product.creator.avatarUrl,
      name: product.creator.name
    },
    priceCents: product.price,
    isPriceFlexible: product.isPwyw || product.options.length > 0,
    currency: product.currency,
    highlightSubstring: highlightSubstring,
    relativeUrl: relativeUrl
  }

  return <CardDisplay {...cardProps} />
}

const CardFromProps: React.FC<ICard> = (props) => {
  return <CardDisplay {...props} />
}

const CardDisplay: React.FC<ICard> = (props) => {
  const price = formatPrice(props.priceCents, props.currency)
  const priceFlexibilityIndicator = props.isPriceFlexible ? '+' : ''
  const formattedPrice = `${price}${priceFlexibilityIndicator}`

  const highlightMatch = (text: string, highlight: string) => {
    if (!highlight) return text
    const parts = text.split(new RegExp(`(${highlight})`, 'gi'))
    return parts.map((part, index) =>
      part.toLowerCase() === highlight.toLowerCase() ? (
        <strong className="text-violet" key={index}>
          {part}
        </strong>
      ) : (
        part
      )
    )
  }

  const productUrl = props.relativeUrl ? new URL(props.url).pathname : props.url
  const creatorUrl = props.relativeUrl ? '/' : props.creator.url

  return (
    <article className="product-card">
      {props.relativeUrl ? (
        <Link to={productUrl} className="stretched-link" aria-label={props.title}>
          <Carousel items={props.carouselItems} />
        </Link>
      ) : (
        <a href={productUrl} className="stretched-link" aria-label={props.title}>
          <Carousel items={props.carouselItems} />
        </a>
      )}

      <header>
        <h4 itemProp="name">{highlightMatch(props.title, props.highlightSubstring || '')}</h4>
        {props.relativeUrl ? (
          <Link
            to={creatorUrl}
            target="_blank"
            className="user"
            style={{ position: 'relative' }}
            rel="noreferrer"
          >
            <img className="user-avatar" src={props.creator.thumbnail} />
            <span>{highlightMatch(props.creator.name, props.highlightSubstring || '')}</span>
          </Link>
        ) : (
          <a
            href={creatorUrl}
            target="_blank"
            className="user"
            style={{ position: 'relative' }}
            rel="noreferrer"
          >
            <img className="user-avatar" src={props.creator.thumbnail} />
            <span>{highlightMatch(props.creator.name, props.highlightSubstring || '')}</span>
          </a>
        )}
      </header>
      <footer>
        <div className="rating" aria-label="Rating">
          <span className="icon icon-solid-star"></span>
          <span className="rating-average">{props.rating}</span>
          <span title={`${props.rating} ratings`}>({props.reviewCount})</span>
        </div>
        <div
          itemScope
          itemProp="offers"
          itemType="https:schema.org/Offer"
          style={{ display: 'flex', alignItems: 'center' }}
        >
          <div className="has-tooltip right" aria-describedby={`product-price-${props.id}`}>
            <div className="price" itemProp="price" content={`${props.priceCents}`}>
              {formattedPrice}
            </div>
            <div role="tooltip" id={`product-price-${props.id}`}>
              {formattedPrice}
            </div>
          </div>
          <link itemProp="url" href={props.url} />
          <div itemProp="availability" hidden>
            https:schema.org/InStock
          </div>
          <div itemProp="priceCurrency" hidden>
            {props.currency}
          </div>
        </div>
      </footer>
    </article>
  )
}

const Card: React.FC<
  ICard | { product: Product; highlightSubstring?: string; relativeUrl?: boolean }
> = (props) => {
  if ('product' in props) {
    return (
      <CardFromProduct
        product={props.product}
        highlightSubstring={props.highlightSubstring || ''}
        relativeUrl={props.relativeUrl || false}
      />
    )
  } else {
    return <CardFromProps {...props} />
  }
}

export default Card
