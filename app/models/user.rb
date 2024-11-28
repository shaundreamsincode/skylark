class User < ApplicationRecord
  has_secure_password # TODO - ensure email is uniq

  ADMIN_EMAILS = [
    "romacubecdmx@gmail.com",
    "foo"
  ].freeze
end
