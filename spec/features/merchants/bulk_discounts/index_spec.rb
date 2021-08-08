require 'rails_helper'

RSpec.describe "The Merchant BulkDiscount index page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Korbanth')
    @discount1 = @merchant1.bulk_discounts.create!(percentage: 0.1, threshold: 3)
    @discount2 = @merchant1.bulk_discounts.create!(percentage: 0.2, threshold: 6)
    @merchant2 = Merchant.create!(name: 'KR Sabers')
    @discount3 = @merchant2.bulk_discounts.create!(percentage: 0.2, threshold: 2)

    visit merchant_bulk_discounts_path(@merchant1.id)
  end

  it "displays the merchant's bulk discounts and their percentage and threshold attributes" do
    expect(page).to have_content(@discount1.id)
    expect(page).to have_content(@discount1.percentage)
    expect(page).to have_content(@discount1.threshold)
    expect(page).to have_content(@discount2.id)
    expect(page).to have_content(@discount2.percentage)
    expect(page).to have_content(@discount2.threshold)
    expect(page).to_not have_content(@discount3.id)
    expect(page).to_not have_content(@discount3.percentage)
    expect(page).to_not have_content(@discount3.threshold)
  end
end
