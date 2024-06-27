class Api::V1::LikesController < ApplicationController
  before_action :set_micropost, only: [:create, :destroy]
  before_action :jwt_authenticate, only: [:create]

  def create
    jwt_authenticate
    return render_unauthorized if @current_user.nil?
    
    token = encode(@current_user.id)
    @micropost = Micropost.find_by(id: params[:id])
    
    if @micropost.nil?
      return render json: { error: "Micropost not found" }, status: :not_found
    end
    
    if @current_user.id == @micropost.user_id
      return render json: { error: "You cannot like your own micropost" }, status: :unprocessable_entity
    end
    
    like = @current_user.likes.create(micropost_id: params[:id])
    
    if like.save
      token = encode(@current_user.id)
      render json: like, serializer: LikeSerializer, status: :created, meta: { token: token }
    else
      render json: { error: like.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end
  
  def destroy
    jwt_authenticate
    return render_unauthorized if @current_user.nil?

    @micropost = Micropost.find_by(id: params[:id])
    
    if @micropost.nil? 
      render json: { error: "Micropost not found" }, status: :not_found
    else
      @like = Like.find_by(micropost_id: params[:id], user_id: @current_user.id)
      if @like.nil?
        render json: { error: 'Like not found' }, status: :not_found
      else
        @like.destroy
        render json: { message: 'Like destroyed successfully' }
      end
  end
end
  private

  def set_micropost
    @micropost = Micropost.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Micropost not found' }, status: :not_found
  end
end
