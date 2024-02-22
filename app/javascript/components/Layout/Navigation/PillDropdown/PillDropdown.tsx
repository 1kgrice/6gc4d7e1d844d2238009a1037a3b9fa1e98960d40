import clsx from 'clsx'
import React, { PropsWithChildren, useMemo, useState, useEffect } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { stickers } from '~/assets/images'
import { Category } from '~/models'
import * as api from '~/network/api'
import { ensureLeadingSlash } from '~/utils/urlHelper'
import { useTheme } from '~/contexts/themeProvider'

interface ICategoryPillDropdown {
  id?: string
  showAll?: boolean
  isChild?: boolean
  parentName: string
  parentLongSlug: string
  backSlug?: string | null
  items?: Category[]
  image?: string
  hidden?: boolean
  mobile?: boolean
  accentColor?: string
  mouseOutCallback?: () => void
  mouseOverCallback?: () => void
}

const CategoryPillDropdown = (props: PropsWithChildren<ICategoryPillDropdown>) => {
  const navigate = useNavigate()
  const { colorTheme } = useTheme()

  const params = useParams<{ category?: string; '*'?: string }>()

  const [data, setData] = useState({
    showAll: props.showAll || false,
    isChild: props.isChild || false,
    parentName: props.parentName,
    parentLongSlug: props.parentLongSlug,
    backSlug: props.backSlug,
    items: props.items || [],
    image: props.image,
    accentColor: props.accentColor
  })

  const accentStyle = useMemo(() => {
    if (data.accentColor) {
      return `bg-${data.accentColor} text-black`
    } else {
      return colorTheme == 'light' ? 'bg-white text-black' : 'bg-black text-white'
    }
  }, [data, colorTheme])

  const handleMouseOver = () => {
    props.mouseOverCallback && props.mouseOverCallback()
  }

  const handleMouseOut = () => {
    props.mouseOutCallback && props.mouseOutCallback()
  }

  function chooseImage(category: Category) {
    if (category) {
      let sticker =
        stickers[category.slug] ||
        category.ancestors?.some((ancestor) => {
          stickers[ancestor.slug]
        }) ||
        null
      console.log(`Sticker for ${category.slug}: ${sticker}`)
      return sticker
    }
    return null
  }

  const fetchAndReplace = async (
    e: React.MouseEvent<HTMLAnchorElement>,
    item: { name?: string; longSlug: string; isNested: boolean }
  ) => {
    e.preventDefault()

    if (item.longSlug == '#') {
      let newData = {
        showAll: props.showAll || false,
        isChild: props.isChild || false,
        parentName: props.parentName,
        parentLongSlug: props.parentLongSlug,
        backSlug: props.backSlug,
        items: props.items || [],
        image: props.image,
        accentColor: props.accentColor
      }
      setData(newData)
    } else if (item.isNested) {
      api
        .getCategoriesByLongSlug({ longSlug: item.longSlug })
        .then((resp) => {
          const categories = resp.categories.map?.((item) => {
            return new Category(item)
          })
          if (categories.length > 0) {
            let category = categories[0]
            let backSlug = category.longSlug.split('/').slice(0, -1).join('/')
            if (props.mobile || props.parentLongSlug == '#') {
              backSlug ||= '#'
            }
            let image = chooseImage(category)
            let newData = {
              showAll: true,
              isChild: true,
              parentName: category.name,
              parentLongSlug: category.longSlug,
              backSlug: backSlug,
              items: category.children,
              image: image,
              accentColor: category.accentColor
            }
            setData(newData)
          }
        })
        .catch((error) => {
          console.error('Error fetching categories:', error)
        })
    } else {
      const uri = item.longSlug[0] == '/' ? item.longSlug : `/${item.longSlug}`
      navigate(uri)
    }
  }

  if (props.mobile) {
    return (
      <div id={props.id} role="menu" aria-label={data.parentName} className={accentStyle}>
        {data.backSlug && (
          <Link
            className={clsx(accentStyle, 'justify-normal')}
            to={ensureLeadingSlash(data.backSlug)}
            style={{ gap: 'var(--spacer-2)' }}
            role="menuitem"
            hidden={!data.isChild}
            onClick={(e) => {
              fetchAndReplace(e, {
                longSlug: data.backSlug || '',
                isNested: true
              })
            }}
          >
            <span className="icon icon-outline-cheveron-left"></span>
            <span>Back</span>
          </Link>
        )}
        {data.showAll && (
          <Link
            className={accentStyle}
            to={ensureLeadingSlash(data.parentLongSlug)}
            role="menuitem"
            onClick={(e) => {
              e.preventDefault()
              let uri = ensureLeadingSlash(data.parentLongSlug)
              if (location.pathname !== uri) {
                navigate(uri)
              }
            }}
          >
            All {data.parentName}
          </Link>
        )}
        {data?.items?.map((item: Category) => {
          return (
            <Link
              className={accentStyle}
              to={ensureLeadingSlash(item.longSlug)}
              role="menuitem"
              aria-haspopup={item.isNested && 'menu'}
              key={`item-${item.slug}`}
              onClick={(e) => {
                fetchAndReplace(e, {
                  longSlug: item.longSlug,
                  isNested: item.isNested
                })
              }}
            >
              {item.name}
            </Link>
          )
        })}
        {data.image && <img src={data.image} className={accentStyle} />}
      </div>
    )
  } else {
    return (
      <div
        id={props.id}
        onMouseOver={handleMouseOver}
        onMouseOut={handleMouseOut}
        className={accentStyle}
      >
        <div
          className={clsx('dropdown')}
          style={
            props.mobile
              ? {}
              : {
                  transform:
                    'translateX(min(1284px - 100% - var(--spacer-4), 0px)); max-width: calc(1512px - 2 * var(--spacer-4))'
                }
          }
        >
          <div role="menu" aria-label={data.parentName}>
            {data.backSlug && (
              <Link
                className={accentStyle}
                to={ensureLeadingSlash(data.backSlug)}
                style={{ justifyContent: 'normal', gap: 'var(--spacer-2)' }}
                role="menuitem"
                hidden={!data.isChild}
                onClick={(e) => {
                  fetchAndReplace(e, {
                    longSlug: data.backSlug || '',
                    isNested: true
                  })
                }}
              >
                <span className="icon icon-outline-cheveron-left"></span>
                <span>Back</span>
              </Link>
            )}
            {data.showAll && (
              <Link
                className={accentStyle}
                to={ensureLeadingSlash(data.parentLongSlug)}
                role="menuitem"
                onClick={(e) => {
                  e.preventDefault()
                  let uri = ensureLeadingSlash(data.parentLongSlug)
                  if (location.pathname !== uri) {
                    navigate(uri)
                  }
                }}
              >
                All {data.parentName}
              </Link>
            )}
            {data?.items?.map((item: Category) => {
              return (
                <Link
                  className={accentStyle}
                  to={ensureLeadingSlash(item.longSlug)}
                  role="menuitem"
                  aria-haspopup={item.isNested && 'menu'}
                  key={`item-${item.slug}`}
                  onClick={(e) => {
                    fetchAndReplace(e, {
                      longSlug: item.longSlug,
                      isNested: item.isNested
                    })
                  }}
                >
                  {item.name}
                </Link>
              )
            })}
            {data.image && <img src={data.image} className={accentStyle} />}
          </div>
        </div>
      </div>
    )
  }
}

export default CategoryPillDropdown
