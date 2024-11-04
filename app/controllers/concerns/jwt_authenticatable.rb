module JwtAuthenticatable
    extend ActiveSupport::Concern
  
    included do
      before_action :authenticate_user
    end
  
    private
  
    def authenticate_user
      return if controller_name == 'sessions' && ['new', 'create'].include?(action_name)
      
      token = cookies.signed[:jwt]
      begin
        @decoded = jwt_decode(token)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        redirect_to login_path
      end
    end
  
    def jwt_decode(token)
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      HashWithIndifferentAccess.new decoded
    end
end
