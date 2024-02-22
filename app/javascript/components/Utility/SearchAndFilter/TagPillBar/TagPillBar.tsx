import React, { useEffect, useState, useMemo } from 'react'
import { Link, useLocation, useNavigate, useParams } from 'react-router-dom'
import { Tag } from '~/models'
import * as api from '~/network/api'
import Skeleton from 'react-loading-skeleton'
import { SkeletonContainer } from '~/components'

const TagPillBar = () => {
  const params = useParams()
  const longSlug = useMemo(() => {
    const { category, '*': wildcard } = params
    return wildcard ? `${category}/${wildcard}` : category
  }, [params])

  const [tags, setTags] = useState<Tag[]>([])
  const [loadingTags, setLoadingTags] = useState<boolean>(false)

  useEffect(() => {
    if (!longSlug) return

    const fetchTags = async () => {
      try {
        setLoadingTags(true)
        const response = await api.getTagsByCategoryLongSlug({ longSlug: longSlug })
        const tagInstances = response.tags.map((tag) => {
          return new Tag(tag)
        })
        setLoadingTags(false)
        setTags(tagInstances)
      } catch (error) {
        setLoadingTags(false)
        console.error('Error fetching tags:', error)
      }
    }

    fetchTags()
  }, [longSlug])

  useEffect(() => {
    setTags([])
  }, [params])

  return (
    <section
      style={{
        position: 'sticky',
        top: '0px',
        zIndex: 'var(--z-index-above-overlay)',
        gap: 'var(--spacer-4)',
        padding: 'var(--spacer-2)',
        overflowX: 'auto',
        display: 'grid',
        gridAutoFlow: 'column',
        alignItems: 'center',
        gridAutoColumns: 'max-content',
        backgroundColor: 'var(--body-bg)'
      }}
    >
      <h5>Popular tags:</h5>
      {!loadingTags &&
        tags.map((tag) => (
          <Link
            key={`tag-${tag.name}`}
            className="pill button"
            to={`?sort=default&tags=${encodeURIComponent(tag.name)}`}
          >
            {tag.name} ({tag.count})
          </Link>
        ))}

      {loadingTags &&
        Array.from({ length: 8 }, (_, index) => (
          <SkeletonContainer key={index} className="rounded-full overflow-hidden">
            <Skeleton width={90} height={36} />
          </SkeletonContainer>
        ))}
    </section>
  )
}

export default TagPillBar
