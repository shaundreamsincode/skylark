class CollaboratorNote < ApplicationRecord
  belongs_to :research_project
  belongs_to :user

  enum entry_type: { report: 0, image: 1, dataset: 2, comment: 3 }
end
