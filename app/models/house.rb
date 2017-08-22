class House < ApplicationRecord
  belongs_to :user
  
  enum status: { interested: 0, not_interested: 1 }
end
