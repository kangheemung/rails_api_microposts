class Api::V1::LikesController < ApplicationController
  before_action :set_micropost, only: [:create, :destroy]
  
  def create
    jwt_authenticate
    return render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized if @current_user.nil?

    if @micropost.user_id == @current_user.id
      return render json: { error: "You cannot like your own post." }, status: :unprocessable_entity
    end

   
    like = @current_user.likes.build(micropost: @micropost)

    if like.save
      render json: like, status: :created
    else
      Rails.logger.info like.errors.full_messages.to_sentence
      render json: { error: like.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end
  
   def destroy
    jwt_authenticate
    return render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized if @current_user.nil?

    like = @current_user.likes.find_by(micropost_id: @micropost.id)
    
    if like.nil?
      render json: { error: "Like not found." }, status: :not_found
    elsif like.destroy
      render json: {}, status: :no_content
    else
      Rails.logger.info like.errors.full_messages.to_sentence
      render json: { error: like.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def set_micropost
    @micropost = Micropost.find(params[:micropost_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Micropost not found." }, status: :not_found
  end

end
