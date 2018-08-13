class User < ApplicationRecord
  # to encrypt password
  has_secure_password

  has_many :messages, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :authentications, dependent: :destroy

  # email need to be unique and with correct format and only validate during create
  validates :email, presence: true, uniqueness: true, format: { with: /\S+@\S+\.\S+/, message: "Email is invalid" }, on: :create
  # password need to have exact length and only validate during create
  validates :password, length: { in: 6..20 }, presence: true, on: :create

  enum role: [:user, :admin]

  # self define method to create user in 2 tables for google
  def self.create_with_auth(auth_hash)
    # normal create with email get from google and generate random password due to validation
    user = self.create(email: auth_hash["info"]["email"], password: SecureRandom.hex(10))

    # create in authentication table with the info from google
    Authentication.create(provider: auth_hash["provider"], uid: auth_hash["uid"], user_id: user.id)

    return user
  end
end