import React, { PropsWithChildren } from 'react'
import { gotGumLogo } from '~/assets/images'

interface INavMenu {}

const NavMenu = (props: PropsWithChildren<INavMenu>) => {
  return (
    <div
      data-animation="default"
      className="navbar w-nav bg-white lg:hidden sm:p-4 lg:p-0"
      data-easing2="linear"
      data-easing="linear"
      data-collapse="medium"
      role="banner"
      data-no-scroll="1"
      data-duration="250"
      data-doc-height="1"
      style={{}}
    >
      <div className="nav-container w-container">
        <a href="/" className="brand homepage w-nav-brand">
          <img src={gotGumLogo} loading="lazy" alt="" className="logo" />
        </a>
      </div>
      <div className="w-nav-overlay" data-wf-ignore="" id="w-nav-overlay-0"></div>
    </div>
  )
}

export default NavMenu
