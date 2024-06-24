class Api::V1::LikesController < ApplicationController
  before_action :set_micropost, only: [:create, :destroy]
  
  def create
    jwt_authenticate
    return render_unauthorized if @current_user.nil?
    
    @micropost = Micropost.find_by(id: params[:micropost_id])
    
    if @micropost.nil?
      return render json: { error: "Micropost not found" }, status: :not_found
    end
    
    existing_like = Like.find_by(user_id: @current_user.id, micropost_id: @micropost.id)
  
    if existing_like
      return render json: { message: "You have already liked this post.", like: existing_like }, status: :ok
    end
  
    like = Like.new(user: @current_user, micropost: @micropost)
  
    if like.save
      render json: like, serializer: LikeSerializer, status: :created, meta: { token: token }
    else
      render_error(like.errors.full_messages.to_sentence, :unprocessable_entity)
    end
  end


  def destroy
    jwt_authenticate
    return render_unauthorized if @current_user.nil?

    like = @current_user.likes.find_by(micropost_id: params[:id])

    if like.nil?
      render json: { error: "Like not found." }, status: :not_found
    elsif like.destroy
      head :no_content
    else
      render_error(like.errors.full_messages.to_sentence, :unprocessable_entity)
    end
  end

  private

  def set_micropost
    @micropost = Micropost.find_by(id: params[:id])
    if @micropost.nil?
      render json: { error: 'Micropost not found' }, status: :not_found
      return
    end
  end
end
