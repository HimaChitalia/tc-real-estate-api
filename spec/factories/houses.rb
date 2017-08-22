FactoryGirl.define do
  factory :house do
    user
    address "7576 New Road"
    city "Edison"
    state "NJ"
    zip "06832"
    category "Single Family"
    latitude "40.002793879"
    longitude "-89.090876868"
    status 0
  end
end
