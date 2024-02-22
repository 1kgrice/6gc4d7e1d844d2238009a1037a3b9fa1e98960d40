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
        {/* <nav role="navigation" className="nav-menu w-nav-menu">
          <a
            href="https://app.gumroad.com/login"
            className="nav-link hidden-login w-inline-block"
            style={{ display: 'none !important' }}
          >
            <div className="nav-link-text">Login</div>
          </a>

          <a
            data-w-id="74b2d8b7-de5a-9e4c-c0ce-c4e4067f3f1c"
            href="https://app.gumroad.com"
            className="nav-link hidden-sign-up w-inline-block"
          >
            <div className="nav-link-text">Dashboard</div>
          </a>

          <a
            data-w-id="26a834a9-196a-c35c-1055-52c655195738"
            href="/features"
            className="nav-link w-inline-block"
          >
            <div className="nav-link-text">Features</div>
            <div className="nav-link-underline" style={{ width: 0 }}></div>
          </a>

          <a
            id="blog-link"
            data-w-id="c358c3e7-418d-f411-4a76-8587c27a2fb7"
            href="/blog"
            className="nav-link w-inline-block"
          >
            <div className="nav-link-text">Blog</div>
            <div className="nav-link-underline" style={{ width: 0 }}></div>
          </a>
          <a
            id="discover"
            data-w-id="c358c3e7-418d-f411-4a76-8587c27a2fbf"
            href="https://discover.gumroad.com/"
            className="nav-link w-inline-block"
          >
            <div className="nav-link-text">Discover</div>
            <div className="nav-link-underline" style={{ width: 0 }}></div>
          </a>
        </nav> */}

        {/* <div className="nav-menu-secondary">
          <a
            href="https://app.gumroad.com/login"
            className="nav-link log-in w-inline-block"
            // style={{ display: 'none' }}
          >
            <div>Login</div>
          </a>

          <a
            href="https://app.gumroad.com"
            className="nav-link sign-up w-inline-block"
            style={{ borderLeft: 0 }}
          >
            <div>Dashboard</div>
          </a>
        </div>
        <div
          data-w-id="8c99b7f0-db1f-4e22-5de3-786530f9515a"
          className="menu-button w-nav-button"
          aria-label="menu"
          role="button"
          aria-controls="w-nav-overlay-0"
          aria-haspopup="menu"
          aria-expanded="false"
        >
          <div className="menu-icon-wrap">
            <div className="menu-line top"></div>
            <div className="menu-line bottom"></div>
          </div>
        </div> */}
      </div>
      <div className="w-nav-overlay" data-wf-ignore="" id="w-nav-overlay-0"></div>
    </div>
  )
}

export default NavMenu
