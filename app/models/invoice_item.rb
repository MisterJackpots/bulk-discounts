class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  enum status: [ :pending, :packaged, :shipped ]

  def item_name
    item.name
  end

  def biggest_discount
    bulk_discounts.where('quantity_threshold <= ?', quantity)
    .order(percentage: :desc)
    .first
  end

  def retail_price_total
    quantity * unit_price
  end

  def biggest_discount_percentage
    biggest_discount.percentage
  end

  def discounted_price_total
    (retail_price_total - (retail_price_total * biggest_discount_percentage / 100.00)).round(0)
  end

end