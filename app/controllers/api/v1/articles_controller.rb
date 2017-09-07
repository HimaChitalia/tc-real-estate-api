class Api::V1::ArticlesController < ApplicationController

  def realestatenews
    
    Article.getArticles()
    @articles = Article.all
    render json: @articles
    

  end

end
