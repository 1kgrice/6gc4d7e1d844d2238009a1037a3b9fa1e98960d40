import React, { useEffect, useMemo, useState } from 'react'
import { useParams } from 'react-router-dom'
import { stickers } from '~/assets/images'
import { CategoryPill } from '~/components'
import { Category } from '~/models'
import * as api from '~/network/api'

const PillNav: React.FC = () => {
  const settings = {
    itemLength: 9,
    pillMoreAnchor: '#',
    pillAllAnchor: '/'
  }

  const params = useParams<{ category?: string; '*'?: string }>()
  const [data, setData] = useState<Category[]>([])

  useEffect(() => {
    api
      .getRootCategories()
      .then((resp) => {
        const categories = resp.categories.map((item) => new Category(item))
        setData(categories)
      })
      .catch((error) => {
        console.error('Error fetching categories:', error)
      })
  }, [params.category])

  const pillAnchor = useMemo(() => {
    const slugs = data.map((category: Category) => category.slug)
    return slugs.indexOf(params.category || '') > settings.itemLength
      ? settings.pillMoreAnchor
      : params.category || settings.pillAllAnchor
  }, [data, params.category])

  const [pillInFocus, setPillInFocus] = useState(pillAnchor)

  const onPillActivate = (slug: string) => {
    setPillInFocus(slug)
  }

  const onPillDeactivate = (slug: string) => {
    if (slug === pillInFocus) {
      setPillInFocus(pillAnchor)
    }
  }

  useEffect(() => {
    setPillInFocus(pillAnchor)
  }, [pillAnchor, params])

  return (
    <>
      <div role="nav">
        <div className="nested-menu hidden xl:inline-block">
          <div role="menubar" aria-busy="false">
            {/* All */}
            <CategoryPill
              id={`category-pill-all`}
              label="All"
              slug={settings.pillAllAnchor}
              longSlug={settings.pillAllAnchor}
              href={settings.pillAllAnchor}
              shouldUnfocus={pillInFocus != settings.pillAllAnchor}
              isInactiveCallback={onPillDeactivate}
              isActiveCallback={onPillActivate}
              isActiveByDefault={window.location.pathname === settings.pillAllAnchor}
            />
            {/* Featured categories */}
            {data.slice(0, settings.itemLength).map((category: Category, index: number) => {
              return (
                <CategoryPill
                  id={`category-pill-${category.id}`}
                  key={`category-pill-${category.slug}`}
                  label={category.name}
                  slug={category.slug}
                  longSlug={category.longSlug}
                  href={category.longSlug}
                  items={category.children}
                  isChild={!category.isRoot}
                  image={stickers[category.slug]}
                  isInactiveCallback={onPillDeactivate}
                  isActiveCallback={onPillActivate}
                  shouldUnfocus={pillInFocus != category.slug}
                  accentColor={category.accentColor}
                />
              )
            })}

            {/* More */}
            {data && data.length > settings.itemLength && (
              <CategoryPill
                id={`category-pill-more`}
                label="More"
                slug={settings.pillMoreAnchor}
                longSlug={settings.pillMoreAnchor}
                href="#"
                ariaLabel="More Categories"
                items={data.slice(settings.itemLength + 1)}
                isInactiveCallback={onPillDeactivate}
                isActiveCallback={onPillActivate}
                shouldUnfocus={pillInFocus != settings.pillMoreAnchor}
                expandable
              />
            )}
          </div>
        </div>
      </div>
    </>
  )
}

export default PillNav
