class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    discount.update(discount_model_params)
    redirect_to merchant_bulk_discount_path(discount.merchant_id, discount.id), notice: "Discount successfully updated."
  end

  private

  def discount_model_params
    params.require(:bulk_discount).permit(:percentage, :threshold)
  end
end
