class UserSerializer < ActiveModel::Serializer
  attributes :id ,:name,:email
  has_many:microposts, serializer: MicropostSerializer
end
