const protocol = process.env.APP_ENV === 'production' ? 'https' : 'http'
export const discoverModuleURL = `${protocol}://discover.${process.env.API_HOST}`
export const dashboardModuleURL = `${protocol}://dashboard.${process.env.API_HOST}`
export const landingModuleURL = `${protocol}://${process.env.API_HOST}`
