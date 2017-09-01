class Api::V1::ContactsController < ApplicationController

  def create
      @contact = Contact.new(params[:contact][:data])
      name = params[:contact][:data][:name]
      @contact.request = request
      if @contact.deliver
        render json: {message: "Thank you for your Email, #{name.capitalize}. I will get back to you shortly!"}
      else
        render json: {message: 'Cannot send message.'}
      end
    end

end
