const apiRoutes = {
  home: '/'
  // signin: '/auth/signin',
  // signup: '/auth/signup',
  // forgotPassword: '/auth/password/new',
  // editPassword: '/auth/password/edit',
  // search: '/search',
  // productSearch: '/search',
  // productDetail: '/product',
  // profile: '/profile',
  // cart: '/cart',
  // orderCreate: '/order/create',
  // orderPayment: '/order/payment',
  // orderComplete: '/order/finished',
  // aboutCompany: '/about/company',
  // termsAndConditions: '/about/terms-and-conditions',
  // merchant: '/merchant',
  // serviceUnavailable: '/503'
}

export function fullPath(route) {
  if (route.startsWith('http')) {
    return route
  } else {
    return `${process.env.NEXT_PUBLIC_HOME_URL}`
  }
}

export default apiRoutes
