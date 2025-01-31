class CategoryTag < ApplicationRecord
  belongs_to :category
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :category_id } # Prevents duplicate tag assignments
end
