class Api::V1::ContactsController < ApplicationController


  def create
      @contact = Contact.new(params[:contact])
      @contact.request = request
      if @contact.deliver
        render json: {message: 'Thank you for your message. We will contact you soon!'}
      else
        render json: {message: 'Cannot send message.'}
      end
    end

end
