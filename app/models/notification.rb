class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :research_project, polymorphic: true

  scope :unread, -> { where(read: false) }
end
