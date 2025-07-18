class Project < ApplicationRecord
  belongs_to :user
  alias_method :owner, :user

  belongs_to :organization, optional: true

  has_many :project_memberships, dependent: :destroy
  alias_method :memberships, :project_memberships

  has_many :project_notes, dependent: :destroy
  alias_method :notes, :project_notes

  has_many :project_tags, dependent: :destroy
  has_many :tags, through: :project_tags

  has_many :information_requests, dependent: :destroy

  validates :title, presence: true

  # todo  - put a uniq constraint to ensure a user can't be marked as a member twice for the
  # same project

  def members
    memberships.where(status: :approved).map(&:user)
  end
end
