import React, { useEffect, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'

const RatingFilter = () => {
  const location = useLocation()
  const navigate = useNavigate()
  const [rating, setRating] = useState('')

  useEffect(() => {
    const params = new URLSearchParams(location.search)
    const ratingValue = params.get('rating') || ''
    setRating(ratingValue)
  }, [location.search])

  const updateSearchParams = (key, value) => {
    const params = new URLSearchParams(location.search)
    if (value) {
      params.set(key, value)
    } else {
      params.delete(key)
    }
    navigate(`?${params.toString()}`, { replace: true })
  }

  const handleRatingChange = (event) => {
    const newRating = event.target.value
    // Toggle functionality: if the selected rating is the same as the current one, remove the filter.
    if (rating === newRating) {
      setRating('') // Clear the rating
      updateSearchParams('rating', '') // Remove the filter from the query
    } else {
      setRating(newRating)
      updateSearchParams('rating', newRating)
    }
  }

  return (
    <div>
      <fieldset role="group">
        <legend>Rating</legend>
        {[4, 3, 2, 1].map((value) => (
          <label key={value}>
            <span className="rating">
              {Array.from({ length: value }, (_, i) => (
                <span key={i} className="icon icon-solid-star"></span>
              ))}
              {Array.from({ length: 5 - value }, (_, i) => (
                <span key={i} className="icon icon-outline-star"></span>
              ))}
              and up
            </span>
            <input
              type="radio"
              className="focus:ring-0"
              aria-label={`${value} stars and up`}
              readOnly
              checked={rating === value.toString()}
              value={value}
              onChange={handleRatingChange}
              onClick={handleRatingChange}
            />
          </label>
        ))}
      </fieldset>
    </div>
  )
}

export default RatingFilter

// import React, { useState, useEffect } from 'react'
// import { useLocation, useNavigate } from 'react-router-dom'

// const RatingFilter = () => {
//   const location = useLocation()
//   const navigate = useNavigate()
//   const [rating, setRating] = useState('')

//   useEffect(() => {
//     const params = new URLSearchParams(location.search)
//     const ratingValue = params.get('rating') || ''
//     setRating(ratingValue)
//   }, [location.search])

//   const updateSearchParams = (key, value) => {
//     const params = new URLSearchParams(location.search)
//     if (value) {
//       params.set(key, value)
//     } else {
//       params.delete(key)
//     }
//     navigate(`?${params.toString()}`, { replace: true })
//   }

//   const handleRatingChange = (event) => {
//     const newRating = event.target.value
//     setRating(newRating)
//     updateSearchParams('rating', newRating)
//   }

//   return (
//     <div>
//       <fieldset role="group">
//         <legend>Rating</legend>
//         {[4, 3, 2, 1].map((value) => (
//           <label key={value}>
//             <span className="rating">
//               {Array.from({ length: value }, (_, i) => (
//                 <span key={i} className="icon icon-solid-star"></span>
//               ))}
//               {Array.from({ length: 5 - value }, (_, i) => (
//                 <span key={i} className="icon icon-outline-star"></span>
//               ))}
//               and up
//             </span>
//             <input
//               type="radio"
//               aria-label={`${value} stars and up`}
//               readOnly
//               checked={rating === value.toString()}
//               value={value}
//               onChange={handleRatingChange}
//             />
//           </label>
//         ))}
//       </fieldset>
//     </div>
//   )
// }

// export default RatingFilter

// const location = useLocation()
// const navigate = useNavigate()
// const [rating, setRating] = useState('')

// // Extract the rating value from URL search params
// useEffect(() => {
//   const params = new URLSearchParams(location.search)
//   const ratingValue = params.get('rating')
//   if (ratingValue) {
//     setRating(ratingValue)
//   } else {
//     setRating('')
//   }
// }, [location.search])

// const handleRatingChange = (e) => {
//   const newRating = e.target.value
//   setRating(newRating)
//   const params = new URLSearchParams(location.search)
//   if (newRating) {
//     params.set('rating', newRating)
//   } else {
//     params.delete('rating')
//   }
//   navigate({ search: params.toString() })
// }
