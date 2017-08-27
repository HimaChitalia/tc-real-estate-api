class Api::V1::LocationController < ApplicationController

  GOOGLE_KEY = ENV["GOOGLE_KEY"]

  def geolocation
    @location = Location.new(location_params)

    if @location.save

      @all_locations = []
      location = "#{@location.latitude},#{@location.longitude}"

      begin
        @resp = Faraday.get 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?' do |req|
          @radius = params[:miles].to_i * 1609.344
          req.params['location'] = location
          req.params['radius'] = @radius
          req.params['type'] = params[:type]
          req.params['key'] = GOOGLE_KEY
          # req.options.timeout = 0
        end

        body = JSON.parse(@resp.body)

        if @resp.success?
          if body["status"] != "ZERO_RESULTS"
            @locationDetails = body["results"]
            @locationDetails.map.with_index(1) do |e, index|
              new_location = {}
              new_location["address"] = e["vicinity"],
              new_location["key"] = index,
              if new_location["rating"] != nil
                new_location["rating"] = e["rating"]
              end
              new_location["name"] = e["name"]
              if e["opening_hours"] && e["opening_hours"]["open_now"] == true
                new_location["open"] = true
              end
              new_location.map do |k, v|
                if v.is_a?(Array)
                    v.pop(2)
                    v.to_s
                end
              end
              @all_locations.push(new_location)
            end
          else
            @error = "#{params[:type]} is not available in #{params[:radius]} Radius. PLease increase search radius and try again!"
          end

        else
          @error = body["meta"]["errorDetail"]
        end

      rescue Faraday::ConnectionFailed
        @error = "There was a timeout. Please try again."
      end

      if @all_locations.any?
        @result = @all_locations
      else
        @result = { message: @error}
      end

      render json: @result

      # render json: @all_locations

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
