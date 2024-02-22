module AppErrors
  class AppError < StandardError
    def initialize(msg = nil, object: nil, options: {})
      super(msg)
      @object = object 
      @options = options
    end 
  end

  module API
    # AppErrors.include self
    class RouteNotFoundError < AppError; end
    class RecordNotFoundError < AppError; end
    class UnauthorizedError < AppError; end
  end

  module Inheritable
    # AppErrors.include self
    class InterfaceNotImplementedError < AppError; end
  end
end