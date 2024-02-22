import React, { useEffect, useMemo, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { Tag } from '~/models'
import Skeleton from 'react-loading-skeleton'
import { SkeletonContainer } from '~/components'

interface ITagFilter {
  tags: Tag[]
  loading?: boolean
}

const TagFilter: React.FC<ITagFilter> = ({ tags, loading }) => {
  const defaultVisibleLimit = 5
  const location = useLocation()
  const navigate = useNavigate()
  const [showAllTags, setShowAllTags] = useState(false)

  // Parse selected tags from URL
  const selectedTags = useMemo(() => {
    const params = new URLSearchParams(location.search)
    const tagsFromURL = params.get('tags')
    return tagsFromURL ? decodeURIComponent(tagsFromURL).split(',') : []
  }, [location.search])

  const handleTagChange = (tag: string): void => {
    const updatedSelectedTags = selectedTags.includes(tag)
      ? selectedTags.filter((t) => t !== tag)
      : [...selectedTags, tag]

    const params = new URLSearchParams(location.search)
    if (updatedSelectedTags.length > 0) {
      params.set('tags', updatedSelectedTags.map(encodeURIComponent).join(','))
    } else {
      params.delete('tags')
    }
    navigate(`?${params.toString()}`, { replace: true })
  }

  const toggleShowAllTags = () => {
    setShowAllTags(true)
  }

  useEffect(() => {
    setShowAllTags(false)
  }, [tags])

  return (
    <div>
      {tags.length > 0 && (
        <fieldset role="group">
          <legend>Tags</legend>
          {(showAllTags ? tags : tags.slice(0, defaultVisibleLimit)).map(({ name, count }) => (
            <label key={`tag-filter-${name}-${count}`}>
              {`${name} (${count})`}
              <input
                type="checkbox"
                checked={selectedTags.includes(name)}
                onChange={() => handleTagChange(name)}
              />
            </label>
          ))}
          {!showAllTags && tags.length > defaultVisibleLimit && (
            <a
              role="button"
              className="block cursor-pointer"
              onClick={toggleShowAllTags}
              style={{ marginTop: '10px' }}
            >
              Load more...
            </a>
          )}
        </fieldset>
      )}
      {tags.length === 0 && (
        <fieldset role="group">
          <legend>Tags</legend>
          {loading &&
            [...Array(defaultVisibleLimit)].map((_, index) => (
              <SkeletonContainer key={`tag-placeholder-${index}`}>
                <Skeleton height={24} width={180} />
              </SkeletonContainer>
            ))}
          {!loading && tags.length == 0 && <p>No tags found</p>}
        </fieldset>
      )}
    </div>
  )
}

export default TagFilter
