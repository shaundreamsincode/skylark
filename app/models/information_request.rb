class InformationRequest < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_one :information_request_response, dependent: :destroy
  alias_method :response, :information_request_response

  before_create :generate_unique_token
  after_create :notify_project_owner

  validates :title, :description, presence: true

  def upsert_response(attributes = {})
    if information_request_response.present?
      information_request_response.update(attributes)
      information_request_response
    else
      build_information_request_response(attributes).tap(&:save)
    end
  end

  private

  def generate_unique_token
    self.token ||= SecureRandom.hex(10)
  end

  def notify_project_owner
    # Don't notify if the request creator is the project owner
    return if user == project.user

    Notification.create(
      user: project.user,
      notifiable: self,
      message: "New information request '#{title}' created for project '#{project.title}'"
    )
  rescue => e
    Rails.logger.error "Failed to create information request notification: #{e.message}"
  end
end
