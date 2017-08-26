class Api::V1::LocationController < ApplicationController

  def geolocation
    @location = Location.new(location_params)
    binding.pry
    if @location.save
      render json: @location
    else
      render json: {
        errors: @location.errors
      }, status: 500
    end
  end

  private

  def location_params
    params.fetch(:location, {}).permit(:address, :city, :state, :zip)
  end

end
