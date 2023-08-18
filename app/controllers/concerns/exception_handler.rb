module ExceptionHandler
    extend ActiveSupport::Concern
  
    included do
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    end
  
    private
  
    def render_error_message(message, status)
      render json: { errors: { base: [message] } }, status: status
    end
  
    def record_not_found(exception)
      render_error_message("Record not found #{exception.message}", :not_found)
    end
end  