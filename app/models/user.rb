class User < ApplicationRecord
  has_secure_password
  has_many :microposts
  # Follows relationships
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  # Followers relationships
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes
  has_many :liked_microposts, through: :likes, source: :micropost
  
  # Follow a user
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end
  
  # Unfollow a user
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end
  
  # Check if following a user
  def following?(user)
    following.include?(user)
  end
end
