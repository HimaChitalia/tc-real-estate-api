class Api::V1::NewsController < ApplicationController

  require 'nokogiri'
  require 'open-uri'

THE_GUARDIAN_KEY = ENV["THE_GUARDIAN_KEY"]

CONTENT_URL = 'https://www.google.com/search?safe=off&biw=1536&bih=481&tbm=nws&'


# puts doc.to_html

  def realestatenews

    @articles = []

    begin
     @resp = Faraday.get 'http://content.guardianapis.com/search?page-size=20&q=property%20and%20real%20estate' do |req|
       req.params['api-key'] = THE_GUARDIAN_KEY
     end

     body = JSON.parse(@resp.body)

     if @resp.success?

       if body["response"]["status"] == "ok"
         real_estate_news = body["response"]["results"]

         real_estate_news.map do |news|
           @article = {}
           @article.merge!(key: news["id"])
           @article.merge!(title: news["webTitle"])
           @article.merge!(url: news["webUrl"])

          #  uri = "#{CONTENT_URL}q=#{news["id"]}"
          #  doc = Nokogiri::HTML(open(uri))
           #
          #  lines = doc.css("div.st").text.force_encoding('UTF-8')
           #
          #   paragraph = JSON.parse([ lines ].to_json).first
           #
          #  @article.merge!(abstract: paragraph)

           @articles << @article
        end
       end
     end


     rescue Faraday::TimeoutError
       @error = "There was a timeout. Please try again."
     end


     render json: @articles


  end

end
