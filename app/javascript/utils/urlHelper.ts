export function ensureLeadingSlash(url) {
  return url.startsWith('/') ? url : `/${url}`
}

export const redirectSubdomain = (subdomain) => {
  const protocol = window.location.protocol
  const hostname = window.location.hostname
  const port = window.location.port
  const params = window.location.pathname.split('/').slice(2).join('/')

  // Check if the current hostname does not match the specified subdomain
  if (!hostname.startsWith(subdomain + '.')) {
    // Construct the new URL
    const portPart = port ? `:${port}` : ''
    const newUrl = `${protocol}//${subdomain}.${hostname}${portPart}/${params}`

    // Redirect to the new URL
    window.location.replace(newUrl)
  }
}

export const convertToGumroadUrl = (originalURL, username) => {
  const parsedURL = new URL(originalURL)
  parsedURL.hostname = `${username}.gumroad.com`
  parsedURL.protocol = 'https'
  parsedURL.port = ''
  return parsedURL.toString()
}

export const getSubdomain = () => {
  const host = window.location.host
  const parts = host.split('.')
  if (parts.length >= 3 && parts[0] !== 'www') {
    return parts[0]
  }
  return null
}