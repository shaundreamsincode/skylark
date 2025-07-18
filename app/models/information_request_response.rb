class InformationRequestResponse < ApplicationRecord
  belongs_to :information_request
  
  validates :content, presence: true

  after_create :create_notification

  private

  def create_notification
    Notification.create(
      user: information_request.user,
      notifiable: information_request,
      message: "Your information request '#{information_request.title}' received a response"
    )
  rescue => e
    Rails.logger.error "Failed to create notification for information request response: #{e.message}"
  end
end
