class User < ApplicationRecord
    has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes, dependent: :destroy
  has_many :liked_microposts, through: :likes, source: :micropost
  
  validates :email, presence: true, uniqueness: true
  
  # Follow a user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  # ユーザーをアンフォローする
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  def already_liked?(micropost)
    likes.exists?(micropost_id: micropost.id)
  end
end
