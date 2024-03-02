class MicropostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id
  belongs_to :user, serializer: UserSerializer
  def name
    object.user.name # Assuming 'name' is an attribute of the User model
  end
end
