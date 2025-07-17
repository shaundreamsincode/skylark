class Tag < ApplicationRecord
  has_many :project_tags
  has_many :projects, through: :project_tags
  has_many :category_tags
  has_many :categories, through: :category_tags

  validates :name, presence: true, uniqueness: true
end
