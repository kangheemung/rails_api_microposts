require_relative '../../lib/tasks/json_web_token'

class AuthenticationController < ApplicationController
  before_action :authenticate_request!, except: [:authenticate]

  def authenticate
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      render json: { auth_token: JsonWebToken.encode({ sub: user.id }) }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end
end
