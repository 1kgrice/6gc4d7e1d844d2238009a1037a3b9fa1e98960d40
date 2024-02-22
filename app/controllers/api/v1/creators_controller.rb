class Api::V1::CreatorsController <  Api::V1::ApiController
  include Api::V1::ResponseCacheable

  has_scope :by_name, as: :name

  def index
    query = params.permit(:name)
    render_with_cache(key: to_key(query)) do
      creators = Creator.by_name(query[:name]).limit(DEFAULT_LIMIT[:creators])
      json_response = render_template_string 'api/v1/creators/index', creators: creators
    end
  end

  def show
    query = params.permit(:username)
    render_with_cache(key: to_key(query)) do
      creator = Creator.find_by(username: query[:username])
      raise AppErrors::API::RecordNotFoundError, 'User not found' unless creator.present?
      json_response = render_template_string 'api/v1/creators/show', creator: creator, show_in_full: true
    end
  end
end
