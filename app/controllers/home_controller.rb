class HomeController < ApplicationController

  def index
    render json: {message: "Home page"}
  end

end
