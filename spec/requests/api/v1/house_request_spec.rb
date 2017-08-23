require 'rails_helper'

RSpec.describe "Api::V1::Carts", type: :request do

  before(:each) do
    @house = create(:house)
    @user = @house.user
    @token = Auth.create_token(@user.id)
    @token_headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer: #{@token}"
    }
    @tokenless_headers = {
      'Content-Type': 'application/json'
    }
  end

  it "it requires all routes to not follow without token" do
    responses = []
    response_bodies = []

    post "/api/v1/houses", params: { address: "1452 my next street", city: "Piscatway", state: "NJ", zip: "09876", category: "Town house", latitude: "76.548661", longitude: "90.897655" }.to_json, headers: @tokenless_headers
    responses << response
    response_bodies << JSON.parse(response.body)

    get "/api/v1/houses/#{@house.id}", headers: @tokenless_headers
    responses << response
    response_bodies << JSON.parse(response.body)

    responses.each { |r| expect(r).to have_http_status(403) }
    response_bodies.each { |body| expect(body["errors"]).to eq([{ "message" => "You must include a JWT token!" }]) }
  end

  it "it requires all routes go with token" do
    responses = []
    response_bodies = []

    post "/api/v1/houses", params: { address: "1452 my next street", city: "Piscatway", state: "NJ", zip: "09876", category: "Town house", latitude: "76.548661", longitude: "90.897655", user_id: @user.id }.to_json, headers: @token_headers
    responses << response
    response_bodies << JSON.parse(response.body)

    get "/api/v1/houses/#{@house.id}", params: {id: @house.id, user_id: @user.id}, headers: @token_headers
    responses << response
    binding.pry
    response_bodies << JSON.parse(response.body)

    responses.each { |r| expect(r).to have_http_status(200) }
    # response_bodies.each { |body| expect(body["errors"]).to eq([{ "message" => "You must include a JWT token!" }]) }
  end
end
