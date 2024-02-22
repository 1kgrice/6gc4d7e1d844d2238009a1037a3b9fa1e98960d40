export function getSecondLevelDomain() {
  const hostname = window.location.hostname
  if (!hostname.includes('.')) {
    return hostname
  }

  const parts = hostname.split('.').reverse()

  let secondLevelDomain = ''
  let topLevelDomain = ''

  if (parts.length >= 2) {
    topLevelDomain = parts[0]
    secondLevelDomain = parts[1]
  }
  return topLevelDomain ? `${secondLevelDomain}.${topLevelDomain}` : secondLevelDomain
}
