import clsx from 'clsx'
import React from 'react'
import { Link } from 'react-router-dom'
import Card, { ICard } from '~/components/Product/Card/Card'
import { SkeletonCard } from '~/components'
import { Product } from '~/models'

interface ICardGroup {
  content: (ICard | Product)[]
  id: string
  title?: string
  url?: string
  show_button?: boolean
  narrow?: boolean
  loading?: boolean
  length?: number
}

const CardGroup: React.FC<ICardGroup> = ({
  content,
  id,
  title,
  url,
  show_button,
  narrow,
  loading,
  length = 3
}) => {
  return loading ? (
    <section>
      <header
        className="flex space-between items-center"
        style={{
          marginBottom: 'var(--spacer-4)'
        }}
      >
        {title && <h2>{title}</h2>}
      </header>
      <div className={clsx('product-card-grid', { narrow: narrow })}>
        {Array.from({ length }, (_, index) => (
          <SkeletonCard key={`skeleton-${index}`} />
        ))}
      </div>
    </section>
  ) : (
    content && content.length > 0 && (
      <section>
        <header
          className="flex items-center justify-between"
          style={{
            marginBottom: 'var(--spacer-4)'
          }}
        >
          {title && <h2>{title}</h2>}
          {content.length == length && show_button && url && (
            <Link className="button" to={url}>
              View all
            </Link>
          )}
        </header>
        <div className={clsx('product-card-grid', { narrow: narrow })}>
          {content.map((item, index) => (
            <Card
              key={`card-${id}-${index}`}
              {...(item instanceof Product ? { product: item } : item)}
            />
          ))}
        </div>
      </section>
    )
  )
}

export default CardGroup
