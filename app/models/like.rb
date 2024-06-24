class Like < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  validates :user_id, uniqueness: { scope: :micropost_id, message: "has already liked this post" }
end
