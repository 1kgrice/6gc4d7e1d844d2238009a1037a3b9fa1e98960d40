import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { CreatorPage, ProductPage } from '~/pages/creator'
import { NotFoundPage } from '~/pages/common'

export const routes = {
  home: '/',
  notFound: '/404'
}

const CreatorRoutes = (
  <Router>
    <Routes>
      <Route path="/" element={<CreatorPage />} />
      <Route path="/l/:permalink" element={<ProductPage />} />
      <Route path="*" element={<NotFoundPage />} />
    </Routes>
  </Router>
)

export default CreatorRoutes
