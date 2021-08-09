require 'rails_helper'

RSpec.describe "The Merchant Bulk Discount edit page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Korbanth')
    @discount1 = @merchant1.bulk_discounts.create!(percentage: 0.1, threshold: 3)
    @discount2 = @merchant1.bulk_discounts.create!(percentage: 0.2, threshold: 6)

    visit edit_merchant_bulk_discount_path(@merchant1.id, @discount1.id)
  end

  it "displays the discounts current attributes pre-poplulated in the form" do
    expect(page).to have_field("bulk_discount_percentage", with: @discount1.percentage)
    expect(page).to have_field("bulk_discount_threshold", with: @discount1.threshold)
  end

  it "only accepts valid input data"

  it "displays an alert message when invalid data is entered"

  it "modifies the bulk discount record and redirects to it's show page" do
    expect(@discount1.percentage).to eq(0.1)
    expect(@discount1.threshold).to eq(3)

    fill_in("bulk_discount_percentage", with: 0.2)
    fill_in("bulk_discount_threshold", with: 6)
    click_button 'Update'

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1.id, @discount1.id))
    @discount1.reload

    expect(@discount1.percentage).to eq(0.2)
    expect(@discount1.threshold).to eq(6)
  end
end
