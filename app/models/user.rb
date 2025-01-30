class User < ApplicationRecord
  has_secure_password

  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :research_projects, foreign_key: :sponsor_id
  has_many :research_project_participation_requests
  has_many :research_project_participation_notes

  before_save :downcase_email

  #   validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  #   validates :password, length: { minimum: 8 }, if: -> { password.present? }

  def research_project_notifications
    Notification.where(target: research_projects, target_type: "ResearchProject")
  end

  def full_name
    first_name + " " + last_name
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
