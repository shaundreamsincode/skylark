class ProjectMembership < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum status: { pending: 0, approved: 1, rejected: 2 }

  after_update :create_status_change_notification, if: :saved_change_to_status?

  private

  def create_status_change_notification
    return unless status.in?(['approved', 'rejected'])
    
    message = case status
              when 'approved'
                "Your membership request for project '#{project.title}' was approved"
              when 'rejected'
                "Your membership request for project '#{project.title}' was rejected"
              end

    Notification.create(
      user: user,
      notifiable: project,
      message: message
    )
  rescue => e
    Rails.logger.error "Failed to create membership status notification: #{e.message}"
  end
end
