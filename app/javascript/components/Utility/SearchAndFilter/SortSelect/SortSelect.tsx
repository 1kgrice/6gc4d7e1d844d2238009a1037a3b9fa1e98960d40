import React, { useEffect, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'

const SortSelect = () => {
  // const { sort } = useParams()
  // const [selectedSort, setSelectedSort] = useState(sort || 'default')

  // const location = useLocation()
  // const navigate = useNavigate()
  // const params = new URLSearchParams(location.search)
  // const initialSort = params.get('sort') || 'default'

  // const [sort, setSort] = useState(initialSort)

  // useEffect(() => {
  //   const newSort = params.get('sort') || 'default'
  //   setSort(newSort)
  // }, [location.search])

  // const handleChange = (event) => {
  //   params.set('sort', event.target.value)
  //   navigate({ search: params.toString() })
  // }

  const location = useLocation()
  const navigate = useNavigate()
  const initialSort = new URLSearchParams(location.search).get('sort') || 'default'
  const [sort, setSort] = useState(initialSort)

  useEffect(() => {
    const params = new URLSearchParams(location.search)
    const newSort = params.get('sort') || 'default'
    setSort(newSort)
  }, [location.search])

  const handleChange = (event) => {
    const newValue = event.target.value
    const params = new URLSearchParams(location.search)
    params.set('sort', newValue)
    navigate({ search: params.toString() }, { replace: true })
  }

  return (
    <div>
      <fieldset>
        <legend>
          <label htmlFor="sort-select">Sort by</label>
        </legend>
        <select id="sort-select" value={sort} onChange={handleChange}>
          <option value="default">Custom</option>
          <option value="newest">Newest</option>
          <option value="hot_and_new">Hot and new</option>
          <option value="highest_rated">Highest rated</option>
          <option value="most_reviewed">Most reviewed</option>
          <option value="price_asc">Price (Low to High)</option>
          <option value="price_desc">Price (High to Low)</option>
        </select>
      </fieldset>
    </div>
  )
}

export default SortSelect
