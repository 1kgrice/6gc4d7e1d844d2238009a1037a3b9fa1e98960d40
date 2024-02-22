import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { HomePage as LandingHomePage } from '~/pages/landing'
import { NotFoundPage } from '~/pages/common'

export const routes = {
  home: '/'
}

const LandingRoutes = (
  <Router>
    <Routes>
      <Route path={routes.home} element={<LandingHomePage />} />
      <Route path="*" element={<NotFoundPage />} />
    </Routes>
  </Router>
)

export default LandingRoutes
