class CatRentalRequestsController < ApplicationController


  def new
    @cats = Cat.all
  end

  def create
    @request = CatRentalRequest.new(request_params)
    if @request.save
      redirect_to cat_url(@request.cat_id)
    else
      render json: @request.errors.full_messages, status: :unprocessable_entity
    end
  end

  def approve
    @request = CatRentalRequest.find_by(id: params[:id])
    if @request.approve!
      redirect_to cat_url(@request.cat_id)
    else
      render json: @request.errors.full_messages
    end
  end

  def deny

  end

  private

  def request_params
      params.require(:cat_rental_request).permit(:cat_id,:start_date,:end_date)
  end
end
