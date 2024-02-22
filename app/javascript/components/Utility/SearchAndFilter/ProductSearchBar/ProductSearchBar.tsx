import React, { useState, useEffect, useCallback, useMemo } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { Product } from '~/models'
import * as api from '~/network/api'
import { placeholderCamera } from '~/assets/images'
import debounce from 'lodash/debounce'
import { ProductImage } from '~/components'
import './ProductSearchBar.scss'

interface IProductSearchBarProps {
  queryMode?: boolean
}

const ProductSearchBar = React.memo(({ queryMode = false }: IProductSearchBarProps) => {
  const [searchQuery, setSearchQuery] = useState('')
  const [products, setProducts] = useState<Product[]>([])
  const [loadingProducts, setLoadingProducts] = useState<boolean>(false)
  const [startedLoadingProducts, setStartedLoadingProducts] = useState<boolean>(false)
  const location = useLocation()
  const navigate = useNavigate()

  const isSearchQueryNonEmpty = searchQuery.length > 0

  const discoverView = useMemo(() => {
    const queryParams = new URLSearchParams(location.search)
    return !!queryParams.get('sort') || !!queryParams.get('query')
  }, [location.search])

  useEffect(() => {
    const searchParams = new URLSearchParams(location.search)
    const searchParam = searchParams.get('query') || ''
    setSearchQuery(searchParam)
  }, [location.search])

  const updateQueryParams = useCallback(
    (query: string) => {
      const searchParams = new URLSearchParams(location.search)
      if (query.length > 0) {
        searchParams.set('query', encodeURIComponent(query))
        if (!searchParams.has('sort')) {
          searchParams.set('sort', 'default')
        }
      } else {
        searchParams.delete('query')
      }
      navigate(`${location.pathname}?${searchParams.toString()}`, { replace: true })
    },
    [navigate, location.pathname, location.search]
  )

  const navigateToSearch = () => {
    const searchParams = new URLSearchParams(location.search)
    searchParams.set('sort', 'default')
    navigate(`${location.pathname}?${searchParams.toString()}`)
  }

  const fetchProducts = useCallback(
    async (query: string) => {
      if (!queryMode && query.length > 0) {
        try {
          setStartedLoadingProducts(true)
          setLoadingProducts(true)
          const resp = await api.getProducts({ name: query, limit: 5 })
          const newProducts = resp.products.map((item) => new Product(item))
          setProducts(newProducts)
          setLoadingProducts(false)
        } catch (error) {
          console.error('Error fetching products:', error)
          setProducts([])
          setLoadingProducts(false)
          setStartedLoadingProducts(false)
        }
      } else {
        updateQueryParams(query)
      }
    },
    [queryMode, updateQueryParams]
  )

  const debouncedSearch = useCallback(
    debounce((query: string) => {
      fetchProducts(query)
    }, 300),
    [fetchProducts]
  )

  useEffect(() => {
    if (!isSearchQueryNonEmpty) {
      setStartedLoadingProducts(false)
      const params = new URLSearchParams(location.search)
      params.delete('query')
      navigate(`?${params.toString()}`, { replace: true })
    }
  }, [searchQuery])

  useEffect(() => {
    if (isSearchQueryNonEmpty) {
      debouncedSearch(searchQuery)
    } else {
      debouncedSearch.cancel()
      setLoadingProducts(false)
      setProducts([])
    }
  }, [searchQuery, debouncedSearch, isSearchQueryNonEmpty])

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchQuery(e.target.value)
  }

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      updateQueryParams(searchQuery)
      e.preventDefault()
    }
  }

  const highlightMatch = (name: string) => {
    if (!searchQuery) return name
    const parts = name.split(new RegExp(`(${searchQuery})`, 'gi'))
    return parts.map((part, index) =>
      part.toLowerCase() === searchQuery.toLowerCase() ? (
        <strong className="text-" key={index}>
          {part}
        </strong>
      ) : (
        part
      )
    )
  }

  return (
    <div className="combobox" style={{ flexGrow: 1 }}>
      <div className="input">
        <span className="icon icon-solid-search"></span>
        <input
          type="search"
          className="product-search-input"
          placeholder="Search products"
          aria-expanded={isSearchQueryNonEmpty}
          aria-autocomplete="list"
          aria-controls="product-list"
          value={searchQuery}
          onChange={handleChange}
          onKeyDown={handleKeyDown}
        />
        {searchQuery && searchQuery.length > 0 && (
          <span
            className="icon icon-solid-x cursor-pointer"
            onClick={(_) => {
              setSearchQuery('')
            }}
          ></span>
        )}
      </div>
      {isSearchQueryNonEmpty && !loadingProducts && startedLoadingProducts && !discoverView && (
        <datalist id="product-list">
          <h3>Products</h3>
          {products.map((product, index) => (
            <a
              key={`search-product-${index}`}
              role="option"
              href={product.url}
              className="hover:bg-cream hover:text-black flex items-center"
              style={{ textDecoration: 'none', gap: 'var(--spacer-4)' }}
            >
              <ProductImage
                src={[product.getMainCoverImage()?.url, placeholderCamera]}
                alt={product.name}
                width={50}
                height={50}
              />
              <div>
                {highlightMatch(product.name)}
                <small>Product by {product.creator.name}</small>
              </div>
            </a>
          ))}

          {products.length == 0 && !loadingProducts && (
            <p className="px-4 py-2">
              {discoverView ? (
                <>Nothing matches the query.</>
              ) : (
                <>
                  Nothing matches the query, try
                  <a
                    href={`?sort=default`}
                    onClick={navigateToSearch}
                    className="pointer underline pl-1"
                  >
                    custom search
                  </a>
                </>
              )}
            </p>
          )}
        </datalist>
      )}
    </div>
  )
})

export default ProductSearchBar
