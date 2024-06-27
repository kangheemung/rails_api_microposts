class Relationship < ApplicationRecord
      # Assuming the existence of a User model
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  # Validations can vary based on requirements
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  
end
