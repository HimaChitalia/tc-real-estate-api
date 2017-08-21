require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    
    it 'requires email, password and username upon creation' do
      user = build(:user, email: nil, username: nil, password: nil)

     expect(user.valid?).to equal(false)
     expect(user.errors.full_messages).to eq([
       "Password can't be blank",
       "Email can't be blank",
       "Email is invalid",
       "Username can't be blank"
     ]) 
    end
    
    it 'requires that email is valid' do 
      create(:user)
      user = build(:user)

      expect(user.valid?).to equal(false)
      expect(user.errors.full_messages).to eq([
        "Email has already been taken"
      ])
    end
    
    it 'requires that an email is valid (contains an @ symbol and a (.com, .org, etc...)' do 
     user1 = build(:user, email: 'hima.com')
     user2 = build(:user, email: 'hima@something')
     user3 = build(:user, email: 'hima')

     expect(user1.valid?).to equal(false)
     expect(user2.valid?).to equal(false)
     expect(user3.valid?).to equal(false)
     expect(user3.errors.full_messages).to eq([
       "Email is invalid"
     ])
   end    
    
  end
  
  describe 'on save' do
    
    it 'hashes a password' do
     user = build(:user)
     user.save

     expect(user.password_digest).not_to equal(user.password)
    end
    
  end
  
  describe "relationships " do
    
    it 'has many houses' do
      user = create(:user)
      user.houses.create

      expect(user.orders.first.id).not_to eq(nil)      
    end
    
    # it 'has many houses that is destroyed upon deletion of user' do 
    #   user = create(:user)
    #   house = user.create_house(status: 'Interested')
    # 
    #   expect(user.house.id).not_to eq(nil)
    # 
    #   user.destroy
    #   house = House.find_by(id: house.id)
    #   
    #   expect(house).to eq(nil)
    # end
      
  end
end
