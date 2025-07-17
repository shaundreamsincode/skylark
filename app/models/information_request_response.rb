class InformationRequestResponse < ApplicationRecord
  belongs_to :information_request
  
  validates :content, presence: true
end
