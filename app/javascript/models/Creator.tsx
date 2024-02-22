export default class Creator {
  name: string
  username: string
  bio: string
  profileUrl: string
  avatarUrl: string

  constructor(json) {
    this.name = json?.name
    this.username = json?.username
    this.bio = json?.bio
    this.profileUrl = json?.profile_url
    this.avatarUrl = json?.avatar_url
  }
}
