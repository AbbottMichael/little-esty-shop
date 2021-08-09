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

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(params[:merchant_id], params[:id]), notice: "Discount successfully deleted."
  end

  def new
    @discount = BulkDiscount.new
  end

  def create
    discount = BulkDiscount.new(discount_model_params)
    if discount.save
      redirect_to merchant_bulk_discounts_path(params[:merchant_id]), notice: "Discount successfully created."
    else
      redirect_to new_merchant_bulk_discount_path(params[:merchant_id]), alert: "Discount not created."
    end
  end

  private

  def discount_model_params
    params.require(:bulk_discount).permit(:percentage, :threshold, :merchant_id)
  end
end
