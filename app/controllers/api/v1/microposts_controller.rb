class Api::V1::MicropostsController < ApplicationController
    def create
      user = User.find(params[:user][:id]) # "user"オブジェクトから"id"を取得
      @micropost = user.microposts.build(microposts_params)
  
      if @micropost.save
        render json: { status: 201, data: @micropost }
      else
        render json: { status: 400, error: "micorposts can't be found" }
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { status: 404, error: "User not found" }
    end
  
    private
  
    def microposts_params
      params.require(:micropost).permit(:title, :body, :user_id)
    end
  end
  