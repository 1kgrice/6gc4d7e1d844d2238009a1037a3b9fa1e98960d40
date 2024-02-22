import clsx from 'clsx'
import React, { PropsWithChildren, useEffect, useRef, useState, useMemo } from 'react'
import { Category } from '~/models'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { PillDropdown } from '~/components'
import { ensureLeadingSlash } from '~/utils/urlHelper'

interface ICategoryPill {
  id: string
  label: string
  href: string
  slug: string
  longSlug: string
  ariaLabel?: string
  expandable?: boolean
  isChild?: boolean
  items?: Category[]
  image?: string
  shouldUnfocus?: boolean
  accentColor?: string
  isActiveByDefault?: boolean
  isActiveCallback?: (slug: string) => void
  isInactiveCallback?: (slug: string) => void
}

const CategoryPill = (props: PropsWithChildren<ICategoryPill>) => {
  const navigate = useNavigate()
  const dropdownId = `pill-menu-${props.id}`
  const pillId = `category-pill-${props.id}`
  const params = useParams<{ category?: string; '*'?: string }>()
  const [active, setActive] = useState(false)
  const hover = useRef(false)
  const [deactivate, setDeactivate] = useState(false)

  const handleMouseOver = () => {
    props.isActiveCallback?.(props.slug)
    setDeactivate(false)
    setActive(true)
    hover.current = true
  }

  const handleMouseOut = () => {
    setDeactivate(true)
    hover.current = false
  }

  const isPopulated = props.items && props.items.length > 0

  const hide = () => {
    if (deactivate && !hover.current) {
      setActive(false)
    }
  }

  useEffect(() => {
    let timeoutId
    if (deactivate) {
      timeoutId = setTimeout(hide, 500)
    }
    return () => clearTimeout(timeoutId)
  }, [deactivate])

  useEffect(() => {
    active ? setDeactivate(false) : props.isInactiveCallback?.(props.slug)
  }, [active])

  const isCurrent = useMemo(() => {
    const { slug, shouldUnfocus, items } = props
    const path = window.location.pathname

    if (slug === '/') {
      return (!shouldUnfocus && path === '/') || (!shouldUnfocus && active)
    } else if (slug === '' || slug === '#') {
      return (
        (!shouldUnfocus && active) ||
        (!shouldUnfocus && items && items.some((item) => path.startsWith(`/${item.slug}`)))
      )
    } else {
      return (!shouldUnfocus && path.startsWith(`/${slug}`)) || (!shouldUnfocus && active)
    }
  }, [params, props.slug, props.shouldUnfocus, props.items, active])

  const safeToShow = !props.shouldUnfocus && active

  return (
    <>
      <div
        className={clsx('popover', safeToShow && isPopulated && 'expanded')}
        onMouseOver={handleMouseOver}
        onMouseOut={handleMouseOut}
        id={pillId}
      >
        <Link
          to={ensureLeadingSlash(props.href)}
          className={clsx('pill', 'button', props.expandable && 'expandable')}
          role="menuitem"
          aria-current={isCurrent}
          aria-haspopup="true"
          aria-expanded={safeToShow}
          aria-controls={dropdownId}
          aria-label={props.ariaLabel}
          onMouseOver={handleMouseOver}
          onClick={(e) => {
            e.preventDefault()
            if (props.href && props.href != '#') {
              let uri = props.href[0] == '/' ? props.href : `/${props.href}`
              if (location.pathname !== uri) {
                navigate(uri)
              }
            }
          }}
        >
          {props.label}
        </Link>
        {safeToShow && isPopulated && (
          <PillDropdown
            id={dropdownId}
            parentName={props.label}
            parentLongSlug={props.longSlug}
            isChild={props.isChild}
            items={props.items}
            image={props.image}
            mouseOutCallback={handleMouseOut}
            mouseOverCallback={handleMouseOver}
            showAll={!props.expandable}
            accentColor={props.accentColor}
          />
        )}
      </div>
    </>
  )
}

export default CategoryPill
