class Api::V1::HousesController < ApplicationController
  before_action :authenticate_token!, only: [:show, :create]
  before_action :set_house, only: [:show]

  def create
    @house = House.new(house_params)
    if @house.save
      render json: @house
    else
      render json: {
        errors: @house.errors
      }, status: 500
    end
  end

  def show
    render json: @house
  end

  private
    def set_house
      @house = House.find(params[:id])
    end

    def house_params
      params.fetch(:house, {}).permit(:address, :city, :state, :zip, :latitude, :longitude, :user_id)
    end
end
