import ProductImage from './ProductImage'
import Creator from './Creator'
import ProductOption from './ProductOption'

interface IProduct {
  id: number
  permalink: string
  name: string
  creator: Creator
  ratings: {
    count: number[]
    average: number
  }
  price: number
  currency: string
  isPwyw: boolean
  pwywSuggestedPrice: number
  url: string
  carouselItems: string[]
  covers: ProductImage[]
  mainCoverId: string
  options: ProductOption[]
  descriptionHTML?: string
  summary?: string
  pAttributes?: { name: string; value: string }[]
  salesCount?: number
  customButtonTextOption?: string
  customViewContentButtonText?: string
}

export default class Product implements IProduct {
  id: number
  permalink: string
  name: string
  creator: Creator
  ratings: { count: number[]; average: number }
  price: number
  currency: string
  isPwyw: boolean
  pwywSuggestedPrice: number
  url: string
  carouselItems: string[]
  covers: ProductImage[]
  mainCoverId: string
  options: ProductOption[]
  descriptionHTML: string
  summary: string
  pAttributes: { name: string; value: string }[]
  salesCount: number
  customButtonTextOption: string
  customViewContentButtonText: string

  private _mainCoverImage?: ProductImage
  private _ratingCount?: number

  constructor(json: any) {
    this.id = Number(json?.id)
    this.permalink = json?.permalink ?? ''
    this.name = json?.name ?? ''
    this.creator = new Creator(json?.creator)
    this.ratings = {
      count: json?.ratings?.count ?? [0, 0, 0, 0, 0],
      average: Number(json?.ratings?.average ?? 0)
    }
    this.price = Number(json?.price ?? 0)
    this.currency = json?.currency ?? ''
    this.isPwyw = Boolean(json?.is_pay_what_you_want ?? false)
    this.pwywSuggestedPrice = Number(json?.pwyw_suggested_price_cents ?? 0)
    this.url = json?.url ?? ''
    this.carouselItems = json?.carousel_items?.map(String) ?? []
    this.covers = json?.covers?.map((item: any) => new ProductImage(item)) ?? []
    this.mainCoverId = json?.main_cover_id ?? ''
    this.options = json?.options?.map((item: any) => new ProductOption(item)) ?? []
    this.descriptionHTML = json?.description_html ?? ''
    this.summary = json?.summary ?? ''
    this.pAttributes = json?.p_attributes ?? []
    this.salesCount = Number(json?.sales_count ?? 0)
    this.customButtonTextOption = json?.custom_button_text_option ?? ''
    this.customViewContentButtonText = json?.custom_view_content_button_text ?? ''
  }

  getMainCoverImage() {
    if (!this._mainCoverImage) {
      this._mainCoverImage =
        this.covers.find((cover) => cover.id === this.mainCoverId) ||
        this.covers[0] ||
        new ProductImage()
    }
    return this._mainCoverImage
  }

  getRatingCount() {
    if (!this._ratingCount)
      this._ratingCount = this.ratings.count.reduce((sum, count) => sum + count, 0)
    return this._ratingCount
  }
}
