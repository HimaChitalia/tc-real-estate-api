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
          #
          #
          #  begin
          #    doc = Nokogiri::HTML(open(uri))
          # rescue OpenURI::HTTPError => error
          #   response = error.io
          #   response.status
          #   # => ["503", "Service Unavailable"]
          #   response.string
          #   # => <!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n<html DIR=\"LTR\">\n<head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><meta name=\"viewport\" content=\"initial-scale=1\">...
          # end


          #  lines = doc.css("div.st")
           #
          #  binding.pry
           #
          #  @data = Hash.from_xml(lines).to_json
           #
          #   # paragraph = JSON.parse([ lines ].to_json).first
           #
          #   binding.pry
           #
          #  @article.merge!(abstract: @data)

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
