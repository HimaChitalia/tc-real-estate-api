class Article < ApplicationRecord
  THE_GUARDIAN_KEY = ENV["THE_GUARDIAN_KEY"]

 def self.getArticles
  #  @articles = []

   begin
    @resp = Faraday.get 'http://content.guardianapis.com/search?page-size=20&q=property%20and%20real%20estate' do |req|
      req.params['api-key'] = THE_GUARDIAN_KEY
    end

    body = JSON.parse(@resp.body)

    if @resp.success?

      if body["response"]["status"] == "ok"
        real_estate_news = body["response"]["results"]

        real_estate_news.map do |news|
          article = Article.new
          article["key"] = news["id"]
          article["title"] = news["webTitle"]
          article["url"] = news["webUrl"]
          
          article.save
          # @article = {}
          # @article.merge!(key: news["id"])
          # @article.merge!(title: news["webTitle"])
          # @article.merge!(url: news["webUrl"])

          # @articles << @article
       end
      end
    end


    rescue Faraday::TimeoutError
      @error = "There was a timeout. Please try again."
    end
 end
 
end
