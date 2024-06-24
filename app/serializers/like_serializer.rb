class LikeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :micropost_id

  def initialize(object, options = {})
    # objectがnilでないことを確認し、nilであれば新しいOpenStructを作成するよう修正
    if object.nil?
      object = OpenStruct.new
    end

    super(object, options)
  end
end
