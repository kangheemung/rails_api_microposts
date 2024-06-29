class Api::V1::RelationshipsController < ApplicationController
    
  def follow
    jwt_authenticate
    return render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized if @current_user.nil?
    
    followed_user = User.find(params[:relationship][:followed_id])

      if @current_user.following?(followed_user)
        render json: { message: 'You are already following this user' }, status: :unprocessable_entity
      else
        relationship = Relationship.new(relationship_params)
      
        if relationship.save
          token = encode(@current_user.id) 
          render json: relationship, serializer: RelationshipSerializer, status: :created, meta: { token: token }
        else
          render json: { error: relationship.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end
    end



  def unfollow
    jwt_authenticate
    return render json: { error: "Unauthorized" }, status: :unauthorized if @current_user.nil?
    
    followed_user = User.find_by(id: params[:relationship][:followed_id]) # Correct the key to access followed_id
    
    if followed_user.nil?
      return render json: { error: 'User not found' }, status: :not_found
    end
    
    relationship = @current_user.active_relationships.find_by(followed_id: followed_user.id)
    
    if relationship.nil?
      return render json: { error: 'Relationship not found' }, status: :not_found
    end
    
    if relationship.destroy
      head :no_content
    else
      render json: { error: "Failed to unfollow user" }, status: :unprocessable_entity
    end
  end

  private

  def relationship_params
    params.require(:relationship).permit(:follower_id, :followed_id)
  end

end