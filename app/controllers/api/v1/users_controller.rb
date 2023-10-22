class Api::V1::UsersController < ApplicationController
    def create
         user=User.new(user_params)
          p"=============new======"
          p params
          p"==================="
      
        if user.save
          p"==============save====="
          p params
          p"==================="
        render json: {status: 201, data: user}
       else
        render json: {status: 400,error: "users can't found"}
       end
    end
    def update
      if user=User.find_by(id:params[:id])
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
