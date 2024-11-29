class User < ApplicationRecord
  ADMIN_EMAILS = %w(shaun@romacube.com julio@romacube.com michael@romacube.com).freeze

  has_secure_password
  has_many :page_views

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  # Callbacks
  before_save :downcase_email

  def is_admin?
    ADMIN_EMAILS.include?(email)
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
