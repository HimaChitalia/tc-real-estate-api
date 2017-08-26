class House < ApplicationRecord
  belongs_to :user

  validates_presence_of :address, :city, :state, :latitude, :longitude
  enum status: { interested: 0, not_interested: 1 }
end
