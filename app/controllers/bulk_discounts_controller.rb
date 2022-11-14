class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
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
      redirect_to new_merchant_bulk_discount_path(merchant)
      flash[:alert] = "Invalid data, please try again"
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find(params[:id])
    if discount.update(discount_params)
      redirect_to merchant_bulk_discount_path(merchant, discount)
    else
      redirect_to edit_merchant_bulk_discount_path(merchant, discount)
      flash[:alert] = "Invalid data, please try again"
    end
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path
  end

  private
  def discount_params
    params.require(:bulk_discount).permit(:percentage,
    :quantity_threshold)
  end

end