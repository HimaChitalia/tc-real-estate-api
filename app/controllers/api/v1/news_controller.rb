class Api::V1::NewsController < ApplicationController

NEWS_API_KEY = ENV["NEWS_API_KEY"]
NEWYORK_TIMES_API = ENV["NEWYORK_TIMES_API"]
THE_GUARDIAN_KEY = ENV["THE_GUARDIAN_KEY"]

 # http://content.guardianapis.com/search?q=real%20estate&api-key=test
  def realestatenews

    @articles = []

    begin
     @resp = Faraday.get 'http://content.guardianapis.com/search?page-size=20&q=property%20and%20real%20estate' do |req|
       req.params['api-key'] = THE_GUARDIAN_KEY
     end

     body = JSON.parse(@resp.body)

    #  render json: body
    # binding.pry
     if @resp.success?
      #  binding.pry

  #      response"=>
  # {"status"=>"ok",
       if body["response"]["status"] == "ok"
        #  binding.pry
         real_estate_news = body["response"]["results"]
        #  binding.pry

         real_estate_news.map do |news|
           @article = {}
           @article.merge!(key: news["id"])
           @article.merge!(title: news["webTitle"])
           @article.merge!(url: news["webUrl"])
          #  binding.pry
           @articles << @article
        end
       end
     end


     rescue Faraday::TimeoutError
       @error = "There was a timeout. Please try again."
     end


     render json: @articles

    # begin
    #  @resp = Faraday.get 'https://api.nytimes.com/svc/topstories/v2/realestate.json' do |req|
    #    req.params['api-key'] = NEWYORK_TIMES_API
    #  end
    # #  http://api.nytimes.com/svc/topstories/v2/{section}.{response-format}?api-key=
    #
    #  @body = JSON.parse(@resp.body)
    #
    # #  render json: @body
    #  if @resp.success?
    #    if @body["status"] == "OK"
    #      real_estate_news = @body["results"]
    #
    #
    #      real_estate_news.map.with_index(1) do |news, index|
    #        @article = {}
    #        @article.merge!(key: index)
    #        @article.merge!(title: news["title"])
    #        @article.merge!(abstract: news["abstract"])
    #        @article.merge!(url: news["url"])
    #        @articles << @article
    #     end
    #    end
    #  end
    #
    #
    #  rescue Faraday::TimeoutError
    #    @error = "There was a timeout. Please try again."
    #  end
    #
    #
    #  render json: @articles

  end

end
