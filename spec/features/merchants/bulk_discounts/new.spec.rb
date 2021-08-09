require 'rails_helper'

RSpec.describe "The Merchant BulkDiscount new page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Korbanth')
    @discount1 = @merchant1.bulk_discounts.create!(percentage: 0.1, threshold: 3)
    @discount2 = @merchant1.bulk_discounts.create!(percentage: 0.2, threshold: 6)

    visit new_merchant_bulk_discount_path(@merchant1.id)
  end

  it "displays a form; when submitted, creates a new bulk discount and redirects to the merchant's bulk discount index page" do
    fill_in("bulk_discount_percentage", with: 0.6)
    fill_in("bulk_discount_threshold", with: 15)
    expect{click_button 'Create'}.to change(BulkDiscount, :count).by(1)

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1.id))

    new_discount = @merchant1.bulk_discounts.last

    expect(new_discount.percentage).to eq(0.6)
    expect(new_discount.threshold).to eq(15)

    within "#all-discounts" do
      within "#discount-#{new_discount.id}" do
        expect(page).to have_content(new_discount.id)
        expect(page).to have_content("#{(new_discount.percentage * 100).round}%")
        expect(page).to have_content(new_discount.threshold)
      end
    end
  end

  it "displays a success message when the discount is created" do
    fill_in("bulk_discount_percentage", with: 0.6)
    fill_in("bulk_discount_threshold", with: 15)
    expect{click_button 'Create'}.to change(BulkDiscount, :count).by(1)

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1.id))
    expect(page).to have_content("Discount successfully created.")
  end

  it "displays a not created message when the discount is not created" do
    fill_in("bulk_discount_percentage", with: 0)
    fill_in("bulk_discount_threshold", with: 0)
    expect{click_button 'Create'}.to change(BulkDiscount, :count).by(0)

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1.id))
    expect(page).to have_content("Discount not created.")
  end
end
