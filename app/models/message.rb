class Message < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :user_id, :message, :category, presence: true
  
  mount_uploader :upload, MediaUploader

  enum category: [:family, :relationship, :study, :work, :others]
end