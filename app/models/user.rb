class User < ApplicationRecord
  has_secure_password
  
  validates_presence_of :email, :username
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A\S+@.+\.\S+\z/
end
