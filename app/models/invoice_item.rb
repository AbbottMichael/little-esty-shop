class InvoiceItem < ApplicationRecord
  enum status: { packaged: 0, pending: 1, shipped: 2 }

  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :unit_price, presence: true, numericality: { only_integer: true }
  validates :status, presence: true, inclusion: { in: InvoiceItem.statuses.keys }

  belongs_to :invoice
  belongs_to :item

  def applied_discount(merchant_id)
    BulkDiscount.joins(merchant: [{ items: [{invoices: :invoice_items}]}])
                .where(merchants: {id: merchant_id}, invoice_items: {invoice_id: self.invoice_id, id: self.id})
                .where('invoice_items.quantity >= bulk_discounts.threshold')
                .select('bulk_discounts.id', 'invoice_items.id AS invoice_item_id', 'invoice_items.quantity', 'bulk_discounts.threshold', 'items.id AS item_id')
                .order(percentage: :desc)
                .take
  end
end
