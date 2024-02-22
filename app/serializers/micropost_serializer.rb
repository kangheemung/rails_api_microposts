class MicropostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :user_id
  belongs_to :user
end