module AppErrors
  module Rescuable
    extend ActiveSupport::Concern
    
    included do
      rescue_from ActiveRecord::RecordNotFound do |e|
        json_response({ message: e.message }, :not_found)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        json_response({ message: e.message }, :unprocessable_entity)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        json_response({ message: e.message }, :unprocessable_entity)
      end

      rescue_from AppErrors::API::RouteNotFoundError do |_|
        json_response({message: "API end point does not exist"}, :bad_request)
      end

      rescue_from AppErrors::API::RecordNotFoundError do |_|
        json_response({message: "The requested resource was not found."}, :not_found)
      end

      rescue_from AppErrors::API::UnauthorizedError do |_|
        json_response({message: "Can't touch this."}, :unauthorized)
      end

    end

    protected
    # List of status codes: Rack::Utils::HTTP_STATUS_CODES
    # List of status code symbols: Rack::Utils::SYMBOL_TO_STATUS_CODE
    def json_response(object, status = :ok)
      render json: object, status: status
    end
  end
end