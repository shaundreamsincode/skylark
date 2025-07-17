class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  def mark_as_read!
    update!(read: true)
  end
end
