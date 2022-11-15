class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  enum status: [ :completed, :cancelled, "in progress" ]

  def formatted_date
    created_at.strftime('%A, %B%e, %Y')
  end

  def numerical_date
    created_at.strftime('%-m/%-e/%y')
  end

  def self.incomplete_invoices
    self.joins(:invoice_items).where.not(invoice_items: {status: 2}).distinct.order(:created_at)
  end

  def total_revenue
    invoice_items.sum("quantity * unit_price")
  end

  def discounted_revenue
    revenue = invoice_items.map do |item|
      item.invoice_item_total
    end
    revenue.sum
  end
end