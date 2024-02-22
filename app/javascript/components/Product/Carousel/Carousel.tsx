import React, { useRef, useState } from 'react'
import ReactPlayer from 'react-player'
import { v4 as uuidv4 } from 'uuid'
import { placeholderCamera } from '~/assets/images'
import Skeleton from 'react-loading-skeleton'
import { SkeletonContainer } from '~/components'
import { Img } from 'react-image'
import './Carousel.scss'

const Carousel = ({ items }) => {
  const carouselLimit = 8
  const [currentIndex, setCurrentIndex] = useState(0)
  const carouselRef = useRef<HTMLDivElement>(null)
  const itemRefs = useRef(items.map(() => uuidv4())) // Generate unique IDs for each item

  const handleClick = (event, action) => {
    event.preventDefault()
    event.stopPropagation()
    action()
  }

  const showNext = () => {
    if (currentIndex < items.length - 1) {
      setCurrentIndex(currentIndex + 1)
    }
  }

  const showPrevious = () => {
    if (currentIndex > 0) {
      setCurrentIndex(currentIndex - 1)
    }
  }

  const showTab = (index) => {
    setCurrentIndex(index)
  }

  const handleMouseEnter = () => {
    if (carouselRef.current) {
      carouselRef.current.classList.add('show-arrows')
    }
  }

  const handleMouseLeave = () => {
    if (carouselRef.current) {
      carouselRef.current.classList.remove('show-arrows')
    }
  }

  return (
    <div
      className="carousel"
      ref={carouselRef}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      {currentIndex < items.length - 1 && (
        <div
          className="arrow next focus:outline-none"
          role="button"
          aria-label="Show next cover"
          tabIndex={0}
          onClick={(e) => handleClick(e, showNext)}
        ></div>
      )}
      {currentIndex > 0 && (
        <div
          className="arrow previous focus:outline-none"
          role="button"
          aria-label="Show previous cover"
          tabIndex={0}
          onClick={(e) => handleClick(e, showPrevious)}
        ></div>
      )}
      <div className="items">
        {items.slice(0, carouselLimit).map((image, index) => (
          <div
            key={`carousel-item-${index}`}
            className={`preview-content item ${index === currentIndex ? 'active' : ''}`}
            style={{ transform: `translateX(-${currentIndex * 100}%)` }}
            role="tabpanel"
            id={itemRefs.current[index]}
          >
            {image.includes('youtube.com') ? (
              <ReactPlayer
                url={image}
                onError={(e) => ((e.target as HTMLImageElement).src = placeholderCamera)}
              />
            ) : (
              <Img
                src={[image, placeholderCamera]}
                onError={(e) => ((e.target as HTMLImageElement).src = placeholderCamera)}
                loader={
                  <SkeletonContainer>
                    <Skeleton width={2000} height={2000} />
                  </SkeletonContainer>
                }
              />
            )}
          </div>
        ))}
      </div>
      {items.length > 1 && (
        <div role="tablist" aria-label="Select a cover">
          {items.map((_, index) => (
            <div
              key={`tab-${index}`}
              role="tab"
              className={`tab ${index === currentIndex ? 'active' : ''}`}
              aria-label={`Show cover ${index + 1}`}
              aria-selected={index === currentIndex ? 'true' : 'false'}
              aria-controls={itemRefs.current[index]}
              onClick={(e) => handleClick(e, () => showTab(index))}
              tabIndex={0}
            ></div>
          ))}
        </div>
      )}
    </div>
  )
}

export default Carousel
