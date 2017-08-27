# require 'crack' # for xml and json
# require 'crack/json' # for just json
# require 'crack/xml' # for just xml

class Api::V1::LocationController < ApplicationController
  GOOGLE_KEY = ENV["GOOGLE_KEY"]
  # respond_to :json

  # http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=<ZWSID>&address=2114+Bigelow+Ave&citystatezip=Seattle%2C+WA

  # https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&type=restaurant&keyword=cruise&key=YOUR_API_KEY
  def geolocation
    @location = Location.new(location_params)
    if @location.save
      # begin
      citystate = "#{@location.city}, #{@location.state}"

      location = "#{@location.latitude},#{@location.longitude}"

      @resp = Faraday.get 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?' do |req|
          req.params['location'] = location
          req.params['radius'] = params[:radius]
          req.params['type'] = params[:type]
          req.params['key'] = GOOGLE_KEY
          # req.options.timeout = 0
        end

        # binding.pry

        @body = JSON.parse(@resp.body)

        render json: @body

      # @resp = Faraday.get 'http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz1fyb7z4chsb_3z9zt' do |req|
      #     req.params['address'] = @location.address
      #     req.params['citystatezip'] = citystate
      #     # req.options.timeout = 0
      #   end

        # @json_resp = Crack::XML.parse(@resp)
        # @body = JSON.parse(@resp.request)

        # render json: @json_sesp
      #   if @resp.success?
      #     @houseDetails = body["responses"]["response"]
      #   else
      #     @error = body["meta"]["errorDetail"]
      #   end
      #
      # rescue Faraday::ConnectionFailed
      #   @error = "There was a timeout. Please try again."
      # end
      # render json: @houseDetails
                    # render :template => 'location', :format => :js
                    # respond_with @location
                    # responder=>
                    # respond_to do |format|
                    #   format.js{render :js => "getHomeInfo();"}
                    # end
                    # render json: @location
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
