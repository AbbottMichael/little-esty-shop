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
    expect(page).to have_content("#{(@discount1.percentage * 100).round}%")
    expect(page).to have_content(@discount1.threshold)
    expect(page).to have_content(@discount2.id)
    expect(page).to have_content("#{(@discount2.percentage * 100).round}%")
    expect(page).to have_content(@discount2.threshold)
    expect(page).to_not have_content(@discount3.id)
  end

  it "displays a link to the show page of each bulk discount listed" do
    within "#all-discounts" do
      within "#discount-#{@discount1.id}" do
        expect(page).to_not have_link("#{@discount2.id}")
        click_on("#{@discount1.id}")
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant1.id, @discount1.id))
      end

      visit merchant_bulk_discounts_path(@merchant1.id)

      within "#discount-#{@discount2.id}" do
        expect(page).to_not have_link("#{@discount1.id}")
        click_on("#{@discount2.id}")
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant1.id, @discount2.id))
      end
    end
  end

  it "displays a link to delete the discount next to each bulk discount listed; the record is deleted after clicking" do
    within "#all-discounts" do
      within "#discount-#{@discount1.id}" do
        expect(page).to have_link("Delete")
        click_on "Delete"
      end

      expect(page).to_not have_content(@discount1.id)

      within "#discount-#{@discount2.id}" do
        expect(page).to have_link("Delete")
        click_on "Delete"
      end

      expect(page).to_not have_content(@discount2.id)
    end
  end
end
