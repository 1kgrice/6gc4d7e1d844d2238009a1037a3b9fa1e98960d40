export default class Tag {
  name: string
  count: number

  constructor(json: { name: string; taggings_count: number }) {
    this.name = json.name
    this.count = Number(json.taggings_count)
  }
}
