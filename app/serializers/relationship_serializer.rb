class RelationshipSerializer < ActiveModel::Serializer
 attributes :id, :follower_id, :followed_id

  # You can also add user-specific serialization if needed
  belongs_to :follower
  belongs_to :followed

end
