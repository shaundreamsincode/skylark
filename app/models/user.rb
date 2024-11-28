class User < ApplicationRecord
  has_secure_password # TODO - ensure email is uniq
  has_many :page_views

  ADMIN_EMAILS = [
    "romacubecdmx@gmail.com",
    "foo"
  ].freeze


  def is_admin?
    ADMIN_EMAILS.include?(email)
  end
end
