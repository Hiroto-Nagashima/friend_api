class User < ApplicationRecord
  has_many :friendships, dependent: :destroy

  validates :name,
    presence: true,
    length: { maximum: 20 },
    uniqueness: true
end
