import React from 'react'
// import { Link } from 'react-router-dom'
import clsx from 'clsx'

export interface IGridSectionButton {
  label: string
  className?: string
  href: string
}

const GridSectionButton: React.FC<IGridSectionButton> = (props) => {
  return (
    <a href={props.href} className="shadow-button-wrap w-inline-block">
      <div className={clsx('shadow-button-text', props.className)}>{props.label}</div>
    </a>
  )
}

export default GridSectionButton
