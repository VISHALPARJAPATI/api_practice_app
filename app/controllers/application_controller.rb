class ApplicationController < ActionController::API
    def authenticate_user
        render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
    end

    def current_user
        request.env['current_user']
    end
end
