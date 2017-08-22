

FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
  factory :user do
    email  { generate(:email) }
    username "hima"
    password "himapassword"
  end
end
