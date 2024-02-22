class Api::V1::ApiController < ApplicationController
  include AppErrors
  include AppErrors::Rescuable
  include Api::V1::ApiHelper
  include Api::V1::JsonCacheHelper
  # include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :null_session
  # skip_before_action :verify_authenticity_token
  
  def route_not_found
    raise AppErrors::API::RouteNotFoundError
  end

  protected 

  def unescape(value)
    CGI::unescape(value)
  end
end