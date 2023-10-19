class Api::V1::MicropostsController < ApplicationController
        def create
            @user=user.find_by(id:params[:id])
           if @post = @user.microposts.build(microposts_params)
              @post.save
                render json: {status: 201, data: microposts}
           else
            render json: {status: 400,error: "micorposts can't found"}
           end
        end
        private
        def microposts_params
          params.require(:microposts).permit(:title,:body,:user_id)
        end
    
    end
    
end
