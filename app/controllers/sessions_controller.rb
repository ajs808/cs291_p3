class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_or_create_by(username: params[:username])
    token = jwt_encode(user_id: user.id)
    cookies.signed[:jwt] = {value: token, httponly: true}
    redirect_to root_path
  end

  def destroy
    cookies.delete(:jwt)
    redirect_to login_path
  end

  private

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
