class LikeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :micropost_id
end
