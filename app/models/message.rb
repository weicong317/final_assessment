class Message < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :user_id, presence: true

  mount_uploader :upload, MediaUploader
end