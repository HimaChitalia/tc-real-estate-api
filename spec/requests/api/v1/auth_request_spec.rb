require 'rails_helper'

RSpec.describe "Api::V1:Users", type: :request do

  before(:each) do
    @user = User.create(
      email: 'b@baani.com',
      username: 'baani',
      password: 'baanipassword'
    )
  end

  describe "POST /auth" do

    describe "on success" do

      before(:each) do
        params = {
          user: {
            email: 'b@baani.com',
            username: 'baani',
            password: 'baanipassword'
          }
        }

        post "/api/v1/auth",
          params: params.to_json,
          headers: { 'Content-Type': 'application/json' }

        @response = response
      end

      it "returns the existing user (from params) and a JWT token" do
        body = JSON.parse(@response.body)

        expect(@response.status).to eq(200)
        expect(body['user']['id']).not_to eq(nil)
        expect(body['user']['email']).to eq('b@baani.com')
        expect(body['user']['password_digest']).to eq(nil)
        expect(body['token']).not_to eq(nil)
      end
    end

    describe "on error" do

      it "unable to find user with email" do
        params = {
          user: {
            email: 'b@hima.com',
            username: 'baani',
            password: 'baanipassword'
          }
        }

        post "/api/v1/auth",
          params: params.to_json,
          headers: { 'Content-Type': 'application/json' }

        body = JSON.parse(response.body)

        expect(response.status).to eq(500)
        expect(body["errors"]).to eq({
          "email"=>["Unable to find a user with the provided email address"]
        })
      end

      it "password does not match the provided email" do
        params = {
          user: {
            email: 'b@baani.com',
            username: 'baani',
            password: 'password'
          }
        }

        post "/api/v1/auth",
          params: params.to_json,
          headers: { 'Content-Type': 'application/json' }

        body = JSON.parse(response.body)

        expect(response.status).to eq(500)
        expect(body["errors"]).to eq({
          "password"=>["Password does not match the provided email"]
        })
      end
    end
  end
end
