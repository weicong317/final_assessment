class Message < ApplicationRecord
  belongs_to :user
  
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :user_id, :message, :category, presence: true
  
  enum category: [:family, :relationship, :study, :work, :others]
  
  # to allow user to upload image when posting message
  mount_uploader :upload, MediaUploader
end