import React, { Fragment } from 'react'
import Mount from '~/mount'
import CreatorRoutes from '~/routes/creator'

const App = () => {
  return <Fragment>{CreatorRoutes}</Fragment>
}

Mount({ App })
