class InformationRequest < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_many :information_request_responses, dependent: :destroy
  alias_method :responses, :information_request_responses

  before_create :generate_unique_token

  validates :title, :description, presence: true

  private

  def generate_unique_token
    self.token ||= SecureRandom.hex(10)
  end
end
