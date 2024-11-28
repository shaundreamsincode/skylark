class User < ApplicationRecord
  ADMIN_EMAILS = ["romacubecdmx@gmail.com shaun@romacube.com julio@romacube.com mikey@romacube.com"].freeze

  has_secure_password
  has_many :page_views

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  def is_admin?
    ADMIN_EMAILS.include?(email)
  end
end
