class ProjectNotification < ApplicationRecord
  belongs_to :user
  belongs_to :project

  scope :unread, -> { where(read: false) }
end
