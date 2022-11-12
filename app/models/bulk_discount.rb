class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoices, through: :merchant
  has_many :invoice_items, through: :invoices

  validates_presence_of :percentage, :quantity_threshold
  validates_numericality_of :percentage, only_integer: true
  validates_numericality_of :quantity_threshold, only_integer: true
end