class User < ApplicationRecord
  has_many :friendships, dependent: :destroy
end
