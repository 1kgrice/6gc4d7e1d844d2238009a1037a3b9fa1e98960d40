export default class Category {
  id: number
  name: string
  slug: string
  longSlug: string
  order: number
  isRoot: boolean
  isNested: boolean
  shortDescription: string
  accentColor: string
  children: Category[]
  ancestors: Category[]
  productCount: number
  creatorCount: number
  salesCount: number

  byOrderAsc = (a, b) => {
    return Number(a.order) - Number(b.order)
  }

  static concatenate(categories1: Category[], categories2: Category[]): Category[] {
    return [...categories1, ...categories2]
  }

  constructor(json) {
    this.id = Number(json?.id)
    this.name = json?.name
    this.slug = json?.slug
    this.longSlug = json?.long_slug
    this.order = Number(json?.order)
    this.isRoot = Boolean(json?.is_root)
    this.isNested = Boolean(json?.is_nested)
    this.shortDescription = json?.short_description
    this.accentColor = json?.accent_color
    this.children = json?.children?.sort(this.byOrderAsc).map?.((item) => {
      return new Category(item)
    })
    this.ancestors = json?.ancestors?.sort(this.byOrderAsc).map?.((item) => {
      return new Category(item)
    })
    this.productCount = Number(json?.product_count)
    this.creatorCount = Number(json?.creator_count)
    this.salesCount = Number(json?.sales_count)
  }
}
