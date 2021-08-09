require 'rails_helper'

RSpec.describe 'The Merchant Bulk Discount show page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Korbanth')
    @discount1 = @merchant1.bulk_discounts.create!(percentage: 0.1, threshold: 3)
    @discount2 = @merchant1.bulk_discounts.create!(percentage: 0.2, threshold: 6)

    visit merchant_bulk_discount_path(@merchant1.id, @discount1.id)
  end

  it "displays the bulk discount's quantity threshold and percentage discount" do
    expect(page).to have_content(@discount1.id)
    expect(page).to have_content("#{(@discount1.percentage * 100).round}%")
    expect(page).to have_content(@discount1.threshold)
    expect(page).to_not have_content(@discount2.id)
  end

  it "displays a link to edit the bulk discount; when clicked, takes user to edit page" do
    expect(page).to have_link('Update Discount')

    click_on('Update Discount')

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1.id, @discount1.id))
  end
end
