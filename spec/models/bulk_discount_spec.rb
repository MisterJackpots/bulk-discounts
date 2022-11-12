require 'rails_helper'

RSpec.describe BulkDiscount do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoices).through(:merchant) }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :quantity_threshold }
    it { should validate_numericality_of(:percentage).only_integer }
    it { should validate_numericality_of(:quantity_threshold).only_integer }
  end
end