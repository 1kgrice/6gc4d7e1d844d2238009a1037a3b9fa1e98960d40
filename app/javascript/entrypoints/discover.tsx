import React from 'react'
import Mount from '~/mount'
import DiscoverRoutes from '~/routes/discover'
import { ThemeProvider } from 'contexts/themeProvider'

const App = () => {
  return <ThemeProvider>{DiscoverRoutes}</ThemeProvider>
}

Mount({ App })
