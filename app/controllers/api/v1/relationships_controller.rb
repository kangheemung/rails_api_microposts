class Api::V1::RelationshipsController < ApplicationController
    
  def follow
    jwt_authenticate
    return render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized if @current_user.nil?
    
    followed_user = User.find_by(id: relationship_params[:followed_id])
  
    if followed_user.nil?
      return render json: { error: 'User not found' }, status: :not_found
    end
  
    relationship = @current_user.active_relationships.find_by(followed_id: followed_user.id)
  
    if relationship
      return render json: { error: 'You are already following this user' }, status: :unprocessable_entity
    end
  
    if @current_user.id == followed_user.id
      return render json: { error: "You cannot follow yourself" }, status: :unprocessable_entity
    end
  
    relationship = @current_user.active_relationships.build(followed_id: followed_user.id)

        Rails.logger.info "================="
        Rails.logger.info params
        Rails.logger.info relationship
        Rails.logger.info @current_user
        Rails.logger.info "================="
         
        if relationship.save
          token = encode(@current_user.id) 
          render json: relationship, serializer: RelationshipSerializer, status: :created, meta: { token: token }
        else
          Rails.logger.info relationship.errors.full_messages.to_sentence
          render json: { error: relationship.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
    end


    def show_relationship
      relationship = Relationship.find(params[:id])
      render json: relationship, serializer: RelationshipSerializer
    end
    # DELETE /users/:id/unfollow
    def unfollow
      jwt_authenticate
      return render json: { error: "Unauthorized" }, status: :unauthorized if @current_user.nil?
    
      followed_user = User.find_by(id: params[:id])
    
      if followed_user.nil?
        return render json: { error: 'User not found' }, status: :not_found
      end
      
      relationship = @current_user.active_relationships.find_by(followed_id: followed_user.id)
    
      if relationship.nil?
        return render json: { error: 'Relationship not found' }, status: :not_found
      end
    
      if relationship.follower == @current_user
        if relationship.destroy
          head :no_content
        else
          render json: { error: "Failed to unfollow user" }, status: :unprocessable_entity
        end
      else
        return render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
      end
    end


  def relationship_params
    params.require(:relationship).permit(:followed_id)
  end
    
end