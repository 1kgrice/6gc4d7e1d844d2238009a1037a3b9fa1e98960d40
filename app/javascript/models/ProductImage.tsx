interface IProductImage {
  id?: string
  url?: string
  originalUrl?: string
  thumbnail?: string
  type?: string
  filetype?: string
  width?: number
  height?: number
  nativeWidth?: number
  nativeHeight?: number
}

export default class ProductImage implements IProductImage {
  id?: string
  url?: string
  originalUrl?: string
  thumbnail?: string
  type?: string
  filetype?: string
  width?: number
  height?: number
  nativeWidth?: number
  nativeHeight?: number

  constructor(json: Partial<IProductImage> = {}) {
    this.id = json.id
    this.url = json.url
    this.originalUrl = json.originalUrl
    this.thumbnail = json.thumbnail
    this.type = json.type
    this.filetype = json.filetype
    this.width = json.width
    this.height = json.height
    this.nativeWidth = json.nativeWidth
    this.nativeHeight = json.nativeHeight
  }
}
