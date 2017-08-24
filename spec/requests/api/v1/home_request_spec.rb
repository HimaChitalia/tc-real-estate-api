require 'rails_helper'

RSpec.describe "Api::V1::Home", type: :request do

  describe "GET /" do

    it "shows the home page" do

      get "/",
        headers: { 'Content-Type': 'application/json' }

      @response = response

      expect(@response.status).to eq(200)
      expect(@response.body).to include("{\"message\":\"Home page\"}")
    end
  end
end
