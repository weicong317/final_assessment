class User < ApplicationRecord
  has_secure_password

  has_many :messages
  has_many :comments

  validates :email, presence: true, uniqueness: true, format: { with: /\S+@\S+\.\S+/, message: "Email is invalid" }
  validates :password, length: { in: 6..20 }

  enum role: [:user, :admin]
end
