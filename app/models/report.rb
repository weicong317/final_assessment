class Report < ApplicationRecord
  belongs_to :user
  belongs_to :message

  validates :user_id, presence: true
  # each user only can report once to 1 message
  validates :message_id, presence: true, uniqueness: { scope: :user_id }
end