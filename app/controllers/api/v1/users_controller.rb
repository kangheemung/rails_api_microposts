class Api::V1::UsersController < ApplicationController
  include JwtAuthenticator
  skip_before_action :jwt_authenticate, only: [:create]
    def index

      #p"========= check request header ======="
      #p request.headers['Authorization']
      #p"===================================="
      render json: {status: 200, data: User.all}
    end
    
    def create
        user=User.new(user_params)
        p"=============new======"
        p params
        p"==================="
        p "user variable"
        p user

        if user.save
          p"==============save====="
          p params
          p"==================="
          token = encode(user.id)
          render json: {status: 201, data: {name: user.name, email: user.email, token: token}}, status: :created
        else
          p "error for user"
          p user.errors.full_messages
          render json: {status: 400,error: "users can't save and create"}
        end
    end
    
    def show
      jwt_authenticate
  
      if @current_user.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
  
      microposts = @current_user.microposts.all
  
      if microposts.exists?
        user_details = {
          id: @current_user.id,
          name: @current_user.name,
          email: @current_user.email
        }
        # No need to encode a new token for showing the microposts
        render json: { status: 200, data: microposts, user: user_details }
      else
        render json: { status: 404, error: "Micropost not found" }
      end
    end

    def update
      if user=User.find_by(id: params[:id])
        p"==============save====="
        p params
        p"==================="
        user.update(user_params)
        user.save
        render json: {status: 201, data: user}
      else
        render json: {status: 400,error: "users can't update"}
      end
    end

    private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
