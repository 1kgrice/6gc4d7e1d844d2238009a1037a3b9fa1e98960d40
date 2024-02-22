import clsx from 'clsx'
import React, { useEffect, useState } from 'react'
import { PillDropdown } from '~/components'
import { Category } from '~/models'
import * as api from '~/network/api'

interface IHamburgerNav {
  id?: string
  expanded?: boolean
  label?: string
  className?: string
}

const HamburgerNav: React.FC<IHamburgerNav> = (props) => {
  const [active, setActive] = useState(false)
  const [data, setData] = useState<Category[]>([])

  useEffect(() => {
    // Fetch categories from API and update state
    api
      .getRootCategories()
      .then((resp) => {
        const categories = resp.categories.map?.((item) => {
          return new Category(item)
        })
        setData(categories)
      })
      .catch((error) => {
        console.error('Error fetching categories:', error)
      })
  }, [])

  return (
    <div role="nav">
      <div className="nested-menu">
        <button
          aria-controls={props.id}
          aria-expanded={props.expanded}
          aria-haspopup="menu"
          aria-label={props.label}
          onClick={() => {
            setActive(true)
          }}
          className="block xl:hidden"
        >
          <span className="icon icon-filter"></span>
        </button>
        <div className={clsx('backdrop', !active && 'hidden')}>
          <span
            className="icon icon-solid-x close"
            role="button"
            aria-label="Close Menu"
            onClick={() => {
              setActive(false)
            }}
          ></span>
          {data && data.length > 0 && (
            <PillDropdown
              mobile
              id={props.id}
              items={data}
              parentLongSlug="/"
              parentName=""
              showAll={true}
              // accentColor={accentColor}
            />
          )}
        </div>
      </div>
    </div>
  )
}

export default HamburgerNav
