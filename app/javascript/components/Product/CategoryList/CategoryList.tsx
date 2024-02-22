import React from 'react'
import { Link } from 'react-router-dom'
import { stickers } from '~/assets/images'
import { Category } from '~/models'
import { ensureLeadingSlash } from '~/utils/urlHelper'
import { formatNumberToKorM } from '~/utils/numbersHelper'

interface CategoryListProps {
  categories: Category[]
}

const CategoryList: React.FC<CategoryListProps> = ({ categories }) => {
  return (
    <div style={{ display: 'grid', gap: 'var(--spacer-6)' }}>
      <div className="paragraphs">
        <h2>Products by category</h2>
        <ol
          style={{
            listStyle: 'none',
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(min(24rem, 100%), 1fr))',
            gap: 'var(--spacer-4)',
            paddingLeft: 0
          }}
        >
          {categories.map((category) => (
            <li key={`category-block-${category.slug}`}>
              <a className="category-card" href={ensureLeadingSlash(category.slug)}>
                <img src={ensureLeadingSlash(stickers[category.slug])} alt={`${category.name}`} />
                <div className="content">
                  <h2>{category.name}</h2>
                  <p>{category.shortDescription}</p>
                  <ul className="inline">
                    <li>
                      <span className="icon icon-person-circle-fill"></span>{' '}
                      {formatNumberToKorM(category.creatorCount)} creators
                    </li>
                    <li>
                      <span className="icon icon-archive-fill"></span>{' '}
                      {formatNumberToKorM(category.productCount)} products
                    </li>
                    <li>
                      <span className="icon icon-solid-currency-dollar"></span>{' '}
                      {formatNumberToKorM(category.salesCount)} sales
                    </li>
                  </ul>
                </div>
              </a>
            </li>
          ))}
        </ol>
      </div>
    </div>
  )
}

export default CategoryList
