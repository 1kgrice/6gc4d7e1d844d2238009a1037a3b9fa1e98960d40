import clsx from 'clsx'
import { useTheme } from 'contexts/themeProvider'
import React from 'react'
import { gCircleAltPink, envelope } from '~/assets/images'
import './Footer.scss'

interface IFooter {
  message?: string | React.ReactNode
  dynamicColor?: boolean
  standardColor?: boolean
  style?: React.CSSProperties
}

const Footer = (props: IFooter) => {
  const { colorTheme } = useTheme()
  return (
    <div
      className={clsx(
        props.dynamicColor && colorTheme == 'dark' && 'bg-black text-white',
        props.dynamicColor && colorTheme == 'light' && 'bg-cream text-black',
        props.standardColor && 'bg-black text-white',
        'border-b-2 border-b-black pt-4 pb-4 lg:pt-12 lg:pb-12'
      )}
      style={props.style}
    >
      <div className="container">
        <div className="footer-grid" style={{ gridRowGap: '3rem' }}>
          <div className="spacing-medium pt-8 md:pt-0 pb-0">
            <h4 className="text-lg">{props.message}</h4>
          </div>
          <div></div>
          <div className="flex-vertical">
            <img
              src={gCircleAltPink}
              loading="lazy"
              alt="gumpling-pink"
              width="24"
              height="24"
              className="footer-gum-icon"
            />
            <div className="text-base">Gumtective, 2024. Exclusively for Gumroad Inc.</div>
          </div>

          <div className="footer-social-icon-grid">
            <div></div>
            <div></div>
            <div></div>
            <div></div>
            <a
              href="https://github.com/1kgrice/6gc4d7e1d844d2238009a1037a3b9fa1e98960d40"
              className="social-link w-inline-block"
            >
              <svg
                width="24"
                height="24"
                viewBox="0 0 100 100"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M48.854 0C21.839 0 0 22 0 49.217c0 21.756 13.993 40.172 33.405 46.69 2.427.49 3.316-1.059 3.316-2.362 0-1.141-.08-5.052-.08-9.127-13.59 2.934-16.42-5.867-16.42-5.867-2.184-5.704-5.42-7.17-5.42-7.17-4.448-3.015.324-3.015.324-3.015 4.934.326 7.523 5.052 7.523 5.052 4.367 7.496 11.404 5.378 14.235 4.074.404-3.178 1.699-5.378 3.074-6.6-10.839-1.141-22.243-5.378-22.243-24.283 0-5.378 1.94-9.778 5.014-13.2-.485-1.222-2.184-6.275.486-13.038 0 0 4.125-1.304 13.426 5.052a46.97 46.97 0 0 1 12.214-1.63c4.125 0 8.33.571 12.213 1.63 9.302-6.356 13.427-5.052 13.427-5.052 2.67 6.763.97 11.816.485 13.038 3.155 3.422 5.015 7.822 5.015 13.2 0 18.905-11.404 23.06-22.324 24.283 1.78 1.548 3.316 4.481 3.316 9.126 0 6.6-.08 11.897-.08 13.526 0 1.304.89 2.853 3.316 2.364 19.412-6.52 33.405-24.935 33.405-46.691C97.707 22 75.788 0 48.854 0z"
                  fill="currentColor"
                />
              </svg>
            </a>
            <a href="mailto:ragozin@hey.com" className="social-link w-inline-block">
              <svg
                width="36"
                height="24"
                viewBox="0 0 33 25"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M5.953 4.002c-2.034 0-3.626.514-3.907 2.469-.09.626.108 1.242.563 1.687.226.22.465.484.78.75.794.669 1.805 1.42 2.75 2.094 2.604 1.85 4.659 3 5.876 3 1.217 0 3.272-1.15 5.875-3 .947-.673 1.958-1.426 2.75-2.094.316-.266.555-.528.78-.75a1.944 1.944 0 0 0 .564-1.687C21.703 4.516 20.11 4 18.077 4H5.953Zm-3.938 6.156v5.844a4 4 0 0 0 4 4h12a4 4 0 0 0 4-4v-5.844a26.122 26.122 0 0 1-3.031 2.5c-2.836 2.008-5.383 3.344-6.97 3.344-1.585 0-4.132-1.336-6.968-3.344a26.037 26.037 0 0 1-3.031-2.5Z"
                  fill="currentColor"
                />
              </svg>
            </a>
            <a href="https://twitter.com/KirillRagozin" className="social-link w-inline-block">
              <svg
                width="24"
                height="24"
                viewBox="0 0 30 25"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M29.4254 0.298606C28.1446 1.20207 26.7264 1.89307 25.2256 2.34501C24.4201 1.41879 23.3495 0.762313 22.1587 0.464359C20.9679 0.166406 19.7143 0.241354 18.5675 0.679067C17.4207 1.11678 16.436 1.89614 15.7466 2.91174C15.0571 3.92734 14.6962 5.13017 14.7127 6.35756V7.69508C12.3622 7.75603 10.0331 7.23472 7.93283 6.17759C5.83257 5.12046 4.02635 3.56033 2.67504 1.63612C2.67504 1.63612 -2.67504 13.6738 9.36263 19.0239C6.60805 20.8937 3.32662 21.8312 0 21.6989C12.0377 28.3865 26.7504 21.6989 26.7504 6.31744C26.7491 5.94488 26.7133 5.57324 26.6434 5.2073C28.0084 3.86108 28.9718 2.16138 29.4254 0.298606Z"
                  fill="currentColor"
                ></path>
              </svg>
            </a>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Footer
