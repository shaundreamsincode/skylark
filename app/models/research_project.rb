class ResearchProject < ApplicationRecord
  belongs_to :sponsor, class_name: "User"
  has_many :collaboration_requests, dependent: :destroy
  has_many :collaborator_notes, dependent: :destroy

  # todo  - put a uniq constraint to ensure that no user can request to join the same
  # project multiple times...

  def approved_collaborators
    collaboration_requests.where(status: :accepted).map(&:user)
  end
end
