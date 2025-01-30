class CollaborationRequest < ApplicationRecord
  belongs_to :research_project
  belongs_to :collaborator, class_name: "User"

  enum status: { pending: 0, accepted: 1, rejected: 2 }
end
