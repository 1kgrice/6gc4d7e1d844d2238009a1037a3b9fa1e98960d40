import React, { ReactNode } from 'react'

export interface IGridHalves {
  children: ReactNode[]
}

const GridHalves: React.FC<IGridHalves> = ({ children }) => {
  return <div className="grid-halves">{children.map((child) => child)}</div>
}

export default GridHalves
