class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :percentage, presence: true, numericality: { less_than: 1, greater_than: 0 }
  validates :threshold, presence: true, numericality: { only_integer: true, greater_than: 0 }

end
