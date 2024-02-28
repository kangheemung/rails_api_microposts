class Api::V1::AuthController < ApplicationController
  skip_before_action :jwt_authenticate, only: [:create]
  def create
    user = User.find_by_email(params[:email])
   if  user&.authenticate(params[:password])
    token = encode(user.id)
    render json: { status:201, data: {name: user.name,email: user.email, token: token}}, status: :created
   else
    render json: {status: 400, error: "invalid email or password"}, status: :bad_request
    
   end
  end 
  def destroy
   render json: { status: 200, message: 'ログアウトしました。' }
  end 
end
