class User < ApplicationRecord
  has_secure_password

  has_many :projects
  has_many :project_memberships
  has_many :project_notes

  before_save :downcase_email

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  def project_notifications
    all_projects = projects + project_memberships.map(&:project)
    ProjectNotification.where(user: user, project: all_projects)
  end

  def full_name
    first_name + " " + last_name
  end

  def is_member?(project)
    project.project_memberships.approved.map(&:user).flatten.include?(self)
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
