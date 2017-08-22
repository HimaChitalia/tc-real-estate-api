class User < ApplicationRecord
  has_secure_password
  
  validates_presence_of :email, :username
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A\S+@.+\.\S+\z/
  
  has_many :houses
  
  before_destroy :destroy_houses

   private

   def destroy_houses
     self.houses.destroy_all
    #  self.houses.reload
    #  self.reload
   end
end
