import React, { PropsWithChildren, ReactElement } from 'react'
import { IGridSectionButton } from '~/components/Landing/GridSectionButton/GridSectionButton'

interface IGridSection {
  variant?: 'text' | 'image'
  className?: string
  textHeader?: string
  textContent?: string | ReactElement
  imgProps?: {
    sizes?: string
    src?: string
    alt?: string
    width?: string
    height?: string
    className?: string
    description?: string | ReactElement
    style?: React.CSSProperties
  }
  button?: ReactElement<IGridSectionButton>
}

const GridSection = (props: PropsWithChildren<IGridSection>) => {
  if (props.variant === 'text') {
    return (
      <div className={props.className}>
        <div className="column-padding p-4">
          <div className="tablet-centered">
            <div className="content-grid home-hero">
              <h1>{props.textHeader}</h1>
              <p className="section-sub-head">
                {props.textContent}
                <br />
              </p>
              {props.button}
            </div>
          </div>
        </div>
      </div>
    )
  } else if (props.variant === 'image') {
    return (
      <div className={props.className}>
        <div className="column-padding centered" style={{ padding: '2vw' }}>
          <div className="callout-wrap">
            <img
              src={props.imgProps?.src}
              loading="lazy"
              height={props.imgProps?.height || 800}
              width={props.imgProps?.width || 800}
              sizes={props.imgProps?.sizes}
              alt={props.imgProps?.alt}
              className={props.imgProps?.className}
              style={props.imgProps?.style}
            />
          </div>
        </div>
      </div>
    )
  } else {
    return <div className={props.className}>{props.children || <></>}</div>
  }
}

export default GridSection
