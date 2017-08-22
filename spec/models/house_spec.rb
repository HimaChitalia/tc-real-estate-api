require 'rails_helper'

RSpec.describe House, type: :model do
  
  describe 'House' do
   it 'has a valid factory' do
    expect(build(:house)).to be_valid
   end
  end
  
  describe 'validations' do
    
    it 'requires address, city, state, zip, latitude and langitude upon creation' do
    
      house = build(:house, address: nil, city: nil, state: nil, zip: nil, latitude: nil, longitude: nil)

     expect(house.valid?).to equal(false)
     expect(house.errors.full_messages).to eq([
       "Address can't be blank",
       "City can't be blank",
       "State can't be blank",
       "Zip can't be blank",
       "Latitude can't be blank",
       "Longitude can't be blank"
     ]) 
    end
  end
    
  describe 'on save' do
    
    it 'requires a user on save' do
      house = build(:house, user: nil)

      expect(house.valid?).to equal(false)
      expect(house.errors.full_messages).to eq(["User must exist"])
    end
    
  end
  
  describe "relationships " do
    
    it 'belongs to user' do
      
      house = build(:house, user: nil)
      user = create(:user)
      user.houses << house
      expect(user.houses.first.id).not_to eq(nil)      
    end
  
  end

end
