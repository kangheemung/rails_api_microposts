class Api::V1::MicropostsController < ApplicationController
  include JwtAuthenticator
  skip_before_action :verify_authenticity_token
  before_action ->(request) { authenticate_request(request) }, only: [:index,:create, :update, :destroy]
  
  def index
  # Assign the value returned by authenticate_request to user_id
      p"=========check======="
      p user_id
      p"================"
    if user_id.nil?
      render json: { status: 401, error: "Unauthorized" }
      return
    end
    token = encode(user_id) 
    user = User.find_by(id: user_id)
    if user.nil?
      render json: { status: 404, error: "User not found" }
      return
    end
    #posts =Post.limit(100)#≤ =データ多い時
        #if posts.count > 0
        #render json: {status: 201, data: posts }
        #else
        #render json:{status:400, error: "posts can't found"}
        #end
    #puts "user parameter check"
    #puts params
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = 100

    offset = (page - 1) * per_page
    microposts = Micropost.order(created_at: :desc).offset(offset).limit(per_page)

    micropost_data = []
    microposts.each do |micropost|
      micropost_data << micropost.as_json(except: [:created_at, :updated_at])
    end

    render json: micropost_data
  
    end
    def create
      user_id = authenticate_request(request) # Assign the value returned by authenticate_request to user_id
      p"================"
      p user_id
      p"================"
      if user_id.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
      token = encode(user_id) # Use the correct user_id here
      user = User.find_by(id: user_id)
      if user.nil?
        render json: { status: 404, error: "User not found" }
        return
      end
    
      micropost = user.microposts.build(micropost_params)
    
      if micropost.save 
        render json: { status: 201, data: micropost, token: token }
      else
        render json: { status: 422, errors: micropost.errors.full_messages }
      end
    end
    def update
      user_id = authenticate_request(request) # Assign the value returned by authenticate_request to user_id
      p"================"
      p user_id
      p"================"
      if user_id.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
    
      token = encode(user_id) # Use the correct user_id here
    
      user = User.find_by(id: user_id)
      
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
          render json:{status: 400,error:"posts not update"}
        end
    end
    def destroy
      user_id = authenticate_request(request) # Assign the value returned by authenticate_request to user_id
      p"================"
      p user_id
      p"================"
      if user_id.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
      token = encode(user_id) # Use the correct user_id here
    
      user = User.find_by(id: user_id)
      
      if user.nil?
        render json: { status: 404, error: "User not found" }
        return
      end
        p"====================="
        p params
        p"====================="
        micropost=Micropost.find_by(id:params[:id])
        micropost.destroy
        render json: { message: 'Micropost deleted successfully' }
    end
  
    private
  
    def micropost_params
      params.require(:micropost).permit(:title, :body, :user_id)
    end
end
  