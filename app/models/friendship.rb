class Friendship < ApplicationRecord
  belongs_to :user

  include ActiveModel::Validations
  validates_with FriendshipValidator

  validates :user_id,
    uniqueness: { scope: :friend_id }

  validates :friend_id,
    presence: true
end
