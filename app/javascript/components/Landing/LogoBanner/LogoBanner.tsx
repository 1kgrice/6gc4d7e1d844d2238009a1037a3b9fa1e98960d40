import React from 'react'
import { gotGumLogo } from '~/assets/images'

const LogoBanner = () => {
  return (
    <div className="px-8 py-6 bg-white border-black border-b-4">
      <img src={gotGumLogo} loading="eager" />
    </div>
  )
}

export default LogoBanner
