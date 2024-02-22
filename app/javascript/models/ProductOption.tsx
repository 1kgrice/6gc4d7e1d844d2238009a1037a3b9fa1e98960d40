export default class ProductOption {
  name?: string
  quantityLeft?: number
  description?: string
  priceDifferenceCents?: number
  isPwyw?: boolean

  constructor(json) {
    this.name = json?.name
    this.quantityLeft = Number(json?.quantity_left)
    this.description = json?.description
    this.priceDifferenceCents = Number(json?.price_difference_cents)
    this.isPwyw = Boolean(json?.is_pwyw)
  }
}
