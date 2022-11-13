class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    @discount = merchant.bulk_discounts.new(discount_params)
    if @discount.save
      redirect_to merchant_bulk_discounts_path
    else
      render 'new'
    end
  end

  private
  def discount_params
    params.require(:bulk_discount).permit(:percentage,
    :quantity_threshold)
  end

end