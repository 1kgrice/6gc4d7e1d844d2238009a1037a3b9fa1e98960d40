import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { CreatorProductPage } from '~/pages/creator'
import { NotFoundPage } from '~/pages/common'

export const routes = {
  home: '/',
  notFound: '/404'
}

const CreatorRoutes = (
  <Router>
    <Routes>
      <Route path="/" element={<CreatorProductPage />} />
      <Route path="/l/:permalink" element={<CreatorProductPage />} />
      <Route path="*" element={<NotFoundPage />} />
    </Routes>
  </Router>
)

export default CreatorRoutes
