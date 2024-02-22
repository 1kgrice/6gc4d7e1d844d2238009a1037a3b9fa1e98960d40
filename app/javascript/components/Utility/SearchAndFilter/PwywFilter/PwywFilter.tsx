import React, { useEffect, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'

const PwywFilter: React.FC = () => {
  const location = useLocation()
  const navigate = useNavigate()

  const searchParams = new URLSearchParams(location.search)
  const [isPwywEnabled, setIsPwywEnabled] = useState(
    searchParams.has('pwyw') && searchParams.get('pwyw') === 'true'
  )

  useEffect(() => {
    const newSearchParams = new URLSearchParams(location.search)
    setIsPwywEnabled(newSearchParams.has('pwyw') && newSearchParams.get('pwyw') === 'true')
  }, [location.search])

  const handleCheckboxChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const updatedSearchParams = new URLSearchParams(location.search)

    if (event.target.checked) {
      updatedSearchParams.set('pwyw', 'true')
    } else {
      updatedSearchParams.delete('pwyw')
    }

    navigate(
      {
        pathname: location.pathname,
        search: updatedSearchParams.toString()
      },
      { replace: true }
    )
  }

  return (
    <div>
      <fieldset role="group">
        <label>
          Pay What You Want
          <input
            type="checkbox"
            role="switch"
            checked={isPwywEnabled}
            onChange={handleCheckboxChange}
          />
        </label>
      </fieldset>
    </div>
  )
}

export default PwywFilter
