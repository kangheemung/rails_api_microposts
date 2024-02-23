class MicropostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :name
  
  belongs_to :user

  def name
    object.user.name # Assuming 'name' is an attribute of the User model
  end
end
