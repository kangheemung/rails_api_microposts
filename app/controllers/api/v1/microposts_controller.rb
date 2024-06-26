class Api::V1::MicropostsController < ApplicationController
  before_action :jwt_authenticate, only: [:create]
    def index
      jwt_authenticate
    
      if @current_user.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
    
      token = encode(@current_user.id)
    
      microposts = Micropost.includes(:likes, :user).order(created_at: :desc)
    
      microposts_data = microposts.map do |micropost|
        liked_by_current_user = micropost.likes.exists?(user_id: @current_user.id)
        followed_by_current_user = User.find(micropost.user_id).followers.exists?(@current_user.id)



    
        {
          id: micropost.id,
          body: micropost.body,
          user_id: micropost.user_id,
          name: micropost.user.name,
          liked_by_current_user: liked_by_current_user,
          followed_by_current_user: followed_by_current_user
        }
      end
    
      render json: { data: microposts_data, token: token }
    end




    def create
    # jwt_authenticateを呼び出して認証する
      jwt_authenticate
    
      if @current_user.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
    
      token = encode(@current_user.id) # 正しいuser_idを使用する
    
      micropost = @current_user.microposts.build(micropost_params)
    
      if micropost.save 
        token = encode(@current_user.id) # 正しいuser_idを使用する
        user_details = {
          id: @current_user.id,
          name: @current_user.name,
          email: @current_user.email
        }
        render json: { data: micropost, user: user_details, token: token }, status: :created
      else
        render json: { errors: micropost.errors.full_messages }, status: :unprocessable_entity
      end
    end  
    
    def show
       jwt_authenticate
      # Authentication is already handled by the before_action
      if @current_user.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
    
      token = encode(@current_user.id) # Encode the current user ID into the token
    
        micropost = Micropost.find_by(id: params[:id])# Ensure the micropost belongs to the current user
    
      if micropost
        render json: { status: 200, data: micropost,  user_name: @current_user.name,token: token }
      else
        render json: { status: 404, error: "Micropost not found" }
      end
    end



    def update
    # jwt_authenticateを呼び出して認証する
      jwt_authenticate
    
      if @current_user.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
    
      token = encode(@current_user.id) # 正しいuser_idを使用する
    
      user = User.find_by(id: params[:user_id])
      
      if user.nil?
        render json: { status: 404, error: "User not found" }
        return
      end
        #p"====================="
        #p params
        #p"====================="
        micropost=Micropost.find_by(id: params[:id])
        #p"====================="
        #p params
        #p"====================="
        if micropost.update(micropost_params)
          p"====================="
          p params
          p"====================="
          render json:{status: 201,data: micropost,user_name: @current_user.name,token: token }
        else
          render json:{status: 400,error: "posts not update"}
        end
    end
    
    def edit
       jwt_authenticate
      # Authentication is already handled by the before_action
      if @current_user.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
  
      token = encode(@current_user.id) # Encode the current user ID into the token
  
      micropost = @current_user.microposts.find_by(id: params[:id]) # Ensure the micropost belongs to the current user
  
      if micropost
        render json: { status: 200, data: micropost,user_name: @current_user.name, token: token }
      else
        render json: { status: 404, error: "Micropost not found" }
      end
    end
    
    def destroy
      jwt_authenticate
      if @current_user.nil?
      render json: { status: 401, error: "Unauthorized" }
      return
      end
      
      micropost = @current_user.microposts.find_by(id: params[:id]) # Change here to scope to the current user's posts
      if micropost.nil?
      render json: { status: 404, error: "Micropost not found" }
      return
      end
      micropost.destroy
      render json: { message: 'Micropost deleted successfully' }, status: :ok
    end
  
    private
  
    def micropost_params
      params.require(:micropost).permit(:title, :body, :user_id)
                                
    end
    def user_details(user_id)
      user = User.find(user_id)
      { id: user.id, name: user.name, email: user.email }
    end
end
  