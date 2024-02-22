import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { DiscoverPage } from '~/pages/discover'
import { NotFoundPage } from '~/pages/common'

export const routes = {
  home: '/',
  homeAbsolute: process.env.DISCOVER_URL,
  notFound: '/404'
}

const DiscoverRoutes = (
  <Router>
    <Routes>
      <Route path="/" element={<DiscoverPage />} />
      <Route path="/:category/*" element={<DiscoverPage />} />
      <Route path="/404" element={<NotFoundPage />} />
    </Routes>
  </Router>
)

export default DiscoverRoutes
