class ApplicationController < ActionController::API
    before_action :set_middleware_instance

    def authenticate_user
        render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
    end

    def current_user
        request.env['current_user']
    end

    private

    # # Creating an instance of the Middleware::Authentication class to access the methods within this class.
    def set_middleware_instance
      @authentication_middleware = Middleware::Authentication.new(nil)
    end
end
