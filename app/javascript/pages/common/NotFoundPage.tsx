import React, { Fragment } from 'react'
import { personAtCrossroads } from '~/assets/images'
import { Helmet } from 'react-helmet'
import { routes } from '~/routes/discover'

export default function NotFoundPage() {
  return (
    <Fragment>
      <Helmet>
        <title>Page not found</title>
      </Helmet>
      <section className="flex flex-col justify-center items-center h-screen text-gray-800">
        <figure className="mb-4">
          <img
            width={256}
            src={personAtCrossroads}
            className="max-w-full h-auto"
            alt="Page not found"
          />
        </figure>
        <h1 className="text-2xl font-bold mb-2">Page not found</h1>
        <hr className="border-t w-full max-w-xs mb-2" />
        <p className="mb-8">The thing you were looking for doesn't exist.</p>
        <nav>
          <a className="button button-primary" href={routes.homeAbsolute}>
            Go home?
          </a>
        </nav>
      </section>
    </Fragment>
  )
}
