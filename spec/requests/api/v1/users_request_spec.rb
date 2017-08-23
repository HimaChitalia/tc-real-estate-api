require 'rails_helper'

RSpec.describe "Api::V1:Users", type: :request do

  describe "POST /users" do

    describe "on sucess" do

      before(:each) do
        params = {
          user: {
            email: 'b@baani.com',
            username: 'baani',
            password: 'baanipassword'
          }
        }

        post "/api/v1/users",
          params: params.to_json,
          headers: { 'Content-Type': 'application/json' }

        @response = response
      end

      it "creates a user from the params" do
        expect(User.all.count).to eq(1)
      end

      it "returns the new user and a JWT Token"
    end

    describe "on error" do

      it "required a valid email or password" do

      end
    end

  end
end
