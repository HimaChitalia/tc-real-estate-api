class Api::V1::ArticlesController < ApplicationController

  def realestatenews

    @articles = Article.all
    render json: @articles
    
  end

end
