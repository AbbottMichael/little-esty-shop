class Invoice < ApplicationRecord
  enum status: { cancelled: 0, 'in progress' => 1, completed: 2 }

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  validates :status, presence: true, inclusion: { in: Invoice.statuses.keys }

  def invoice_revenue
    invoice_items.sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def invoice_revenue_discounted(merchant_id)
    total_discount = BulkDiscount.joins(merchant: [{ items: :invoice_items }])
      .where(merchants: {id: merchant_id}, invoice_items: {invoice_id: self.id})
      .where('invoice_items.quantity >= bulk_discounts.threshold')
      .select('bulk_discounts.id', 'invoice_items.id AS invoice_item_id', 'invoice_items.quantity', 'invoice_items.unit_price', 'bulk_discounts.threshold', 'bulk_discounts.percentage', 'items.id AS item_id', 'invoice_items.invoice_id AS invoice_id')
      .sum("(invoice_items.unit_price * (bulk_discounts.percentage)) * invoice_items.quantity")
      
      self.invoice_revenue - total_discount
  end
end
