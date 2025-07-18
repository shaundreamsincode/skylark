class ProjectNote < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum entry_type: { report: 0, image: 1, dataset: 2, comment: 3 }

  validates :title, presence: true
  validates :content, presence: true

  after_create :notify_project_members

  private

  def notify_project_members
    # Notify project owner and all approved members (except the note creator)
    users_to_notify = [project.user] + project.members
    users_to_notify = users_to_notify.uniq - [user] # Exclude the note creator
    
    # Only proceed if there are users to notify
    return if users_to_notify.empty?

    users_to_notify.each do |member|
      Notification.create(
        user: member,
        notifiable: project,
        message: "New note '#{title}' added to project '#{project.title}'"
      )
    rescue => e
      Rails.logger.error "Failed to create project note notification for user #{member.id}: #{e.message}"
    end
  end
end
