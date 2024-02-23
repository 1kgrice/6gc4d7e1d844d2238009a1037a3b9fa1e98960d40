import _API from '~/network/network'

const appEnv = `${process.env.APP_ENV}`
const apiHost = `${process.env.API_HOST}`
const apiVersion = `${process.env.API_VERSION}`

export const apiBase = () => {
  const protocol = appEnv === 'production' ? 'https:' : 'http:'
  const protocolRegex = /^(http:\/\/|https:\/\/)/
  const sanitizedApiHost = apiHost.replace(protocolRegex, '')
  return `${protocol}//${sanitizedApiHost}/api/${apiVersion}`
}

export const getCategories = (params = {}) => {
  return _API.get(`${apiBase()}/categories`, { params: params })
}

export const getCategoriesByLongSlug = (params) => {
  let requestParams = {}
  requestParams['by_long_slug'] = encodeURIComponent(params.longSlug)
  let cacheId = `get-categories-${requestParams['long_slug']}`
  return _API.get(`${apiBase()}/categories`, { params: requestParams, id: cacheId })
}

export const getCategoryByLongSlug = (params) => {
  let requestParams = {}
  requestParams['long_slug'] = encodeURIComponent(params.longSlug)
  let cacheId = `get-category-${requestParams['long_slug']}`
  return _API.get(`${apiBase()}/categories/${requestParams['long_slug']}`, { id: cacheId })
}

export const getRootCategories = () => {
  let requestParams = {}
  requestParams['root'] = true
  let cacheId = 'get-root-categories'
  return _API.get(`${apiBase()}/categories`, { params: requestParams, id: cacheId })
}

export const getProduct = (params = {}) => {
  let requestParams = {}
  requestParams['id'] = params['id']
  return _API.get(`${apiBase()}/products/${requestParams['id']}`)
}

const buildProductsRequestParams = (params) => {
  let requestParams = {}
  requestParams['name'] = params['name']
  requestParams['query'] = params['query']
  requestParams['category'] = params['category']
  requestParams['tags'] = params['tags']
  requestParams['rating'] = params['rating']
  requestParams['min_price'] = params['min_price']
  requestParams['max_price'] = params['max_price']
  requestParams['creator'] = params['creator']
  requestParams['limit'] = params['limit']
  requestParams['from'] = params['from']
  requestParams['pwyw'] = params['pwyw']
  requestParams['sort'] = params['sort']
  return requestParams
}

export const getProducts = (params = {}) => {
  // Explicitly declare the request parameters to be sent to the API
  let requestParams = buildProductsRequestParams(params)
  return _API.get(`${apiBase()}/products`, { params: requestParams })
}

export const getProductsFromSearch = (params = {}) => {
  // Explicitly declare the request parameters to be sent to the API
  let requestParams = buildProductsRequestParams(params)
  return _API.get(`${apiBase()}/products/search`, { params: requestParams })
}

export const getCreator = (params) => {
  let username = params['username']
  let cacheId = `get-creator-${username}`
  return _API.get(`${apiBase()}/creators/${username}`, {id: cacheId})
}

export const getCreatorProduct = (params) => {
  let username = params['username']
  let permalink = params['permalink']
  let cacheId = `get-creator-${username}-product-${permalink}`
  return _API.get(`${apiBase()}/creators/${username}/products/${permalink}`, {id: cacheId})
}

export const getHotAndNewProducts = (params = {}) => {
  let requestParams = {}
  requestParams['hot_and_new'] = true
  requestParams['limit'] = params['limit'] ?? 3
  requestParams['category'] = params['category'] ?? ''
  let cacheId = `get-products-hot-and-new-${requestParams['category']}-${requestParams['limit']}`
  return _API.get(`${apiBase()}/products`, { params: requestParams, id: cacheId })
}

export const getTopPwywProducts = (params = {}) => {
  let requestParams = {}
  requestParams['pwyw'] = true
  requestParams['limit'] = params['limit'] ?? 3
  requestParams['sort'] = 'highest_rated'
  requestParams['category'] = params['category'] ?? ''
  let cacheId = `get-products-pwyw-${requestParams['category']}-${requestParams['limit']}`
  return _API.get(`${apiBase()}/products`, { params: requestParams, id: cacheId })
}

export const getShowcaseProducts = (params = {}) => {
  let requestParams = {}
  requestParams['showcase'] = true
  requestParams['limit'] = params['limit'] ?? 5
  requestParams['category'] = params['category'] ?? ''
  let cacheId = `get-products-showcase-${requestParams['category']}-${requestParams['limit']}`
  return _API.get(`${apiBase()}/products`, { params: requestParams, id: cacheId })
}

export const getBestSellingProducts = (params = {}) => {
  let requestParams = {}
  requestParams['featured'] = true
  requestParams['limit'] = params['limit'] ?? 3
  requestParams['category'] = params['category'] ?? ''
  let cacheId = `get-products-best-selling-${requestParams['category']}-${requestParams['limit']}`
  return _API.get(`${apiBase()}/products`, { params: requestParams, id: cacheId })
}

export const getStaffPickedProducts = (params = {}) => {
  let requestParams = {}
  requestParams['staff_picks'] = true
  requestParams['limit'] = params['limit'] ?? 5
  requestParams['category'] = params['category'] ?? ''
  let cacheId = `get-products-staff-picks-${requestParams['category']}-${requestParams['limit']}`
  return _API.get(`${apiBase()}/products`, { params: requestParams, id: cacheId })
}

export const getTagsByCategoryLongSlug = (params) => {
  let requestParams = {}
  requestParams['category'] = encodeURIComponent(params.longSlug)
  let cacheId = `get-tags-${requestParams['category']}`

  return _API.get(`${apiBase()}/tags`, { params: requestParams, id: cacheId })
}