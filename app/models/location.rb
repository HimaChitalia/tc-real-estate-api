class Location < ApplicationRecord

  geocoded_by :full_street_address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  validates_presence_of :address, :city, :state

  private

    def full_street_address
      [address, city, state, zipcode].compact.join(", ")
    end
end
