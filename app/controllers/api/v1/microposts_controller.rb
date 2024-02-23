class Api::V1::MicropostsController < ApplicationController
  
    def index
      # Call jwt_authenticate to perform authentication
      jwt_authenticate
    
      # If @current_user is nil, respond with Unauthorized
      if @current_user.nil?
        render json: { status: 401, error: "Unauthorized" } and return
      end
    
      # If we have a current user, proceed to find microposts
      user = User.find_by(id: @current_user.id)
      
      # If the user is not found, respond with User not found
      if user.nil?
        render json: { status: 404, error: "User not found" } and return
      end
      
      # Pagination parameters
      page = params[:page].present? ? params[:page].to_i : 1
      per_page = 100
      offset = (page - 1) * per_page
      
      # Retrieve paginated microposts
      microposts = Micropost.order(created_at: :desc).offset(offset).limit(per_page)
      
      # Serialize microposts using the specified serializer
      render json: microposts, each_serializer: MicropostSerializer
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
        render json: { status: 201, data: micropost, token: token }
      else
        render json: { status: 422, errors: micropost.errors.full_messages }
      end
    end
    def show
      # Authentication is already handled by the before_action
      if @current_user.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
  
      token = encode(@current_user.id) # Encode the current user ID into the token
  
      micropost = @current_user.microposts.find_by(id: params[:id]) # Ensure the micropost belongs to the current user
  
      if micropost
        render json: { status: 200, data: micropost, token: token }
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
          render json:{status: 201,data: micropost,token: token }
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
        render json: { status: 200, data: micropost, token: token }
      else
        render json: { status: 404, error: "Micropost not found" }
      end
    end
    
    def destroy
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
        p"====================="
        p params
        p"====================="
        micropost=Micropost.find_by(id: params[:id])
        micropost.destroy
        render json: { message: 'Micropost deleted successfully' }
    end
  
    private
  
    def micropost_params
      params.require(:micropost).permit(:title, :body, :user_id)
    end
end
  