class Api::V1::LikesController < ApplicationController
  before_action :set_micropost, only: [:create, :destroy]

  def create
    jwt_authenticate
    return render_unauthorized if @current_user.nil?
  
    if @micropost.user_id == @current_user.id
      return render json: { error: "You cannot like your own post." }, status: :unprocessable_entity
    end
  
    existing_like = @current_user.likes.find_by(micropost: @micropost)
    if existing_like
      return render json: { error: "You have already liked this post." }, status: :unprocessable_entity
    end
  
    like = @current_user.likes.build(micropost: @micropost)
  
    if like.save
      render json: like, serializer: LikeSerializer, status: :created
    else
      render_error(like.errors.full_messages.to_sentence, :unprocessable_entity)
    end
    
    ## Add this check to handle serialization of null values ##
    if like.nil?
      render json: {}, status: :no_content
    end
  end


  def destroy
    jwt_authenticate
    return render_unauthorized if @current_user.nil?

    like = @current_user.likes.find_by(micropost: @micropost)

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
    rescue ActiveRecord::RecordNotFound
    render json: { error: 'Micropost not found' }, status: :not_found
  end

  def render_unauthorized
    render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized
  end

  def render_error(message, status)
    Rails.logger.info message
    render json: { error: message }, status: status
  end
end
