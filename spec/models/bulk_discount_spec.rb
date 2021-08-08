require 'rails_helper'

RSpec.describe BulkDiscount do
  describe 'associations' do
    it {should belong_to :merchant}
  end

  describe 'validations' do
    it { should validate_presence_of(:percentage) }
    it { should validate_numericality_of(:percentage).is_less_than(1).is_greater_than(0) }
    it { should validate_presence_of(:threshold) }
    it { should validate_numericality_of(:threshold).only_integer.is_greater_than(0) }
  end
end
