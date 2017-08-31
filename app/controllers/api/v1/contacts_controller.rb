class Api::V1::ContactsController < ApplicationController


  def create
      @contact = Contact.new(params[:contact])
      @contact.request = request
      binding.pry
      if @contact.deliver
        render json: {message: 'Thank you for your message. We will contact you soon!'}
      else
        binding.pry
        render json: {message: 'Cannot send message.'}
      end
    end



  private


    # def house_params
    #   params.fetch(:house, {}).permit(:address, :city, :state, :zip, :latitude, :longitude, :user_id)
    # end
end
