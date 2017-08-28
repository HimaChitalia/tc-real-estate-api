class Api::V1::LocationController < ApplicationController

  GOOGLE_KEY = ENV["GOOGLE_KEY"]

  def geolocation
    @location = Location.new(location_params)

    if @location.save

      @all_locations = {}

      @train_stations_locations = []
      @school_locations = []
      @hospital_locations = []
      @pharmacy_locations = []
      @restaurant_locations = []

      @orig_location = "#{@location.latitude},#{@location.longitude}"

      train_details()
      school_details()
      hospital_details()
      pharmacy_details()
      restaurant_details()

      if @train_stations_locations.any?
        @all_locations.merge!(trains: @train_stations_locations.first(1))
      end

      if @hospital_locations.any?
        @all_locations.merge!(hospitals: @hospital_locations.first(1))
      end

      if @pharmacy_locations.any?
        @all_locations.merge!(pharmacies: @pharmacy_locations.first(5))
      end

      if @school_locations.any?
        @all_locations.merge!(schools: @school_locations)
      end

      if @restaurant_locations.any?
        @all_locations.merge!(restaurants: @restaurant_locations)
      end

      render json: @all_locations

    else
      render json: {
        errors: @location.errors
      }, status: 500
    end
  end


  def train_details

    get_details('train_station', @train_stations_locations)

  end

  def hospital_details

    get_details('hospital', @hospital_locations)

  end

  def pharmacy_details

    get_details('pharmacy', @pharmacy_locations)

  end

  def school_details

    get_details('school', @school_locations)

  end

  def restaurant_details

    get_details('restaurant', @restaurant_locations)

  end


  private

  def location_params
    params.fetch(:location, {}).permit(:address, :city, :state, :zip)
  end

  def get_details(object, arrayObject)

    begin
      @resp = Faraday.get 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?' do |req|
        req.params['rankby'] = 'distance'
        req.params['location'] = @orig_location
        req.params['type'] = object
        req.params['key'] = GOOGLE_KEY
      end

      @body = JSON.parse(@resp.body)

      if @resp.success?
        if @body["status"] != "ZERO_RESULTS"

          @locationDetails = @body["results"]
          @locationDetails.map.with_index(1) do |e, index|
            @new_location = {}
            @new_location["address"] = e["vicinity"]
            @new_location["latitude"] = e["geometry"]["location"]["lat"]
            @new_location["longitude"] = e["geometry"]["location"]["lng"]
            @new_location["key"] = index
            @new_location["name"] = e["name"]
            if @new_location["rating"] != nil
              @new_location["rating"] = e["rating"]
            end

            begin
              @new_rspn = Faraday.get 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial' do |req|
                destination = "#{@new_location["latitude"]},#{@new_location["longitude"]}"
                req.params['origins'] = @orig_location
                req.params['destinations'] = destination
                req.params['key'] = GOOGLE_KEY
              end
              body_new = JSON.parse(@new_rspn.body)

              if @new_rspn.success?
                if body_new["status"] == "OK"
                  @new_location["distance"] = body_new["rows"][0]["elements"][0]["distance"]["text"]
                  @new_location["travel_time"] = body_new["rows"][0]["elements"][0]["duration"]["text"]
                end
              else
                @error = body["meta"]["errorDetail"]
              end

            rescue Faraday::ConnectionFailed
              @error = "There was a timeout. Please try again."
            end

            arrayObject.push(@new_location)

          end

        end

      else
        @error = body["meta"]["errorDetail"]
      end

    rescue Faraday::ConnectionFailed
      @error = "There was a timeout. Please try again."
    end

  end

end
