class Project < ApplicationRecord
  belongs_to :user
  alias_method :owner, :user

  has_many :project_memberships, dependent: :destroy
  alias_method :memberships, :project_memberships

  has_many :project_notes, dependent: :destroy
  alias_method :notes, :project_notes

  # todo  - put a uniq constraint to ensure a user can't be marked as a member twice for the
  # same project

  def members
    memberships.where(status: :accepted).map(&:user)
  end
end
