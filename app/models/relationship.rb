class Relationship < ApplicationRecord
      # Assuming the existence of a User model
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  # Validations can vary based on requirements
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validate :not_self
    private
    
    def not_self
    errors.add(:follower_id, "can't be the same as followed_id") if follower_id == followed_id
    end
end
