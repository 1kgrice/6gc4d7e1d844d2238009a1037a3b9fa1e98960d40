import debounce from 'lodash/debounce'
import React, { useCallback, useEffect, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import './PriceFilter.scss'
import { currencyInfo } from '~/utils/currencyHelper'

interface Price {
  min: string
  max: string
}

const PriceFilter: React.FC = () => {
  const location = useLocation()
  const params = new URLSearchParams(location.search)
  const navigate = useNavigate()
  const isPwywActive = params.has('pwyw')
  const [selectedCurrency, setSelectedCurrency] = useState('USD')

  // const handleCurrencyChange = (event) => {
  //   setSelectedCurrency(event.target.value)
  // }

  const [price, setPrice] = useState<Price>({ min: '', max: '' })

  // Validate price range
  const isValidPriceRange = (min: string, max: string) => {
    const minNum = min === '' ? -Infinity : parseFloat(min)
    const maxNum = max === '' ? Infinity : parseFloat(max)
    return minNum <= maxNum
  }

  // Update the URL search parameters
  const updateURL = useCallback(
    debounce((newPrice: Price) => {
      const currentMin = params.get('min_price')
      const currentMax = params.get('max_price')

      // Check if newPrice matches the current URL search params
      const isMinEqual = newPrice.min === currentMin || (newPrice.min === '' && currentMin === null)
      const isMaxEqual = newPrice.max === currentMax || (newPrice.max === '' && currentMax === null)

      if (isMinEqual && isMaxEqual) {
        // If both min and max prices match the current URL, don't update the URL.
        return
      }

      // Update URL params only if there's a change
      if (newPrice.min) params.set('min_price', newPrice.min)
      else params.delete('min_price')

      if (newPrice.max) params.set('max_price', newPrice.max)
      else params.delete('max_price')

      navigate(`?${params.toString()}`, { replace: true })
    }, 150),
    [navigate, location.search]
  )

  // Synchronize state with URL search parameters
  useEffect(() => {
    const params = new URLSearchParams(location.search)
    setPrice({
      min: params.get('min_price') || '',
      max: params.get('max_price') || ''
    })
  }, [location.search])

  const handleNumericInput = (type: 'min' | 'max') => (e: React.ChangeEvent<HTMLInputElement>) => {
    let sanitizedValue = e.target.value.replace(/[^\d]/g, '') // Remove non-digits
    sanitizedValue = sanitizedValue === '00' ? '0' : sanitizedValue // Convert "00" to "0"

    if (sanitizedValue !== '' || price[type] !== '') {
      setPrice({ ...price, [type]: sanitizedValue })
    }
  }

  const handleBlur = (type: 'min' | 'max') => {
    const params = new URLSearchParams(location.search)
    const valueFromQuery = params.get(`${type}_price`) || ''
    if (!isValidPriceRange(price.min, price.max)) {
      // Reset to value from query if validation fails
      setPrice((prev) => ({
        ...prev,
        [type]: valueFromQuery
      }))
    }
  }

  // Automatically update URL if price state is valid
  useEffect(() => {
    if (isValidPriceRange(price.min, price.max)) {
      updateURL(price)
    }
  }, [price, updateURL])

  return (
    <div className="flex flex-col" style={{ gap: '10px' }}>
      {/* <label htmlFor="currency">Currency</label>
      <select
        id="currency"
        className="input"
        value={selectedCurrency}
        onChange={handleCurrencyChange}
      >
        {Object.entries(currencyInfo).map(([abbreviation, { symbol }]) => (
          <option key={abbreviation} value={abbreviation}>
            {symbol} ({abbreviation})
          </option>
        ))}
      </select> */}
      <fieldset disabled={isPwywActive}>
        <legend>
          <label htmlFor="min-price">Minimum price</label>
        </legend>
        <div className="input">
          <div className="pill">{currencyInfo[selectedCurrency]['symbol']}</div>
          <input
            id="min-price"
            placeholder="0"
            type="text"
            min="0"
            value={price.min}
            onChange={handleNumericInput('min')}
            onBlur={() => handleBlur('min')}
          />
        </div>
      </fieldset>
      <fieldset disabled={isPwywActive}>
        <legend>
          <label htmlFor="max-price">Maximum price</label>
        </legend>
        <div className="input">
          <div className="pill">{currencyInfo[selectedCurrency]['symbol']}</div>
          <input
            id="max-price"
            placeholder="∞"
            type="text"
            min="0"
            value={price.max}
            onChange={handleNumericInput('max')}
            onBlur={() => handleBlur('max')}
          />
        </div>
      </fieldset>
    </div>
  )
}

export default PriceFilter
