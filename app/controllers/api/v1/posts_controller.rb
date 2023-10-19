class Api::V1::PostsController < ApplicationController
    def index
        posts=Post.all
        if posts.count > 0
            render json: {status: 201, data: posts}
        else
            render json: {status: 400,error: "posts can't found"}
        end
    end
    def create
        @post = Post.new(
        content: params[:content],
         user_id: @current_user.id #ログインユーザーのidを取得して保存
   )
    end
    private
    def microposts_params
      params.require(:microposts).permit(:title,:body,:user_id)
    end

end
