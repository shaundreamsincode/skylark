class PageView < ApplicationRecord
  belongs_to :user, optional: true # Optional for non-logged-in users
end
