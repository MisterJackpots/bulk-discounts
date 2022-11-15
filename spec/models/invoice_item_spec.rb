require 'rails_helper'


RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  describe 'enums' do
    it { should define_enum_for(:status) }
  end

  before :each do
    @merchant1 = Merchant.create!(name: "Billy's Baby Book Barn")
    @merchant2 = Merchant.create!(name: "Candy's Child Compendium Collection")
    @discount1 = BulkDiscount.create!(percentage: 20, quantity_threshold: 2, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage: 15, quantity_threshold: 1, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage: 30, quantity_threshold: 3, merchant_id: @merchant1.id)
    @item1 = @merchant1.items.create!(name: "Learn to Count, Dummy!", description: "Educational Children's Book", unit_price: 2417)
    @item2 = @merchant1.items.create!(name: "Go to Sleep Please, Mommy Just Wants to Watch Leno", description: "Baby Book", unit_price: 1531)
    @item3 = @merchant2.items.create!(name: "There ARE More Than Seven Animals But This is a Good Start", description: "Educational Children's Book", unit_price: 2100)
    @mary = Customer.create!(first_name: "Mary", last_name: "Mommy")
    @daniel = Customer.create!(first_name: "Daniel", last_name: "Daddy")
    @annie = Customer.create!(first_name: "Annie", last_name: "Auntie")
    @invoice1 = @mary.invoices.create!(status: 2)
    @invoice2 = @daniel.invoices.create!(status: 2)
    @invoice3 = @annie.invoices.create!(status: 2)
    @invoiceitem1 = InvoiceItem.create!(item: @item1, invoice: @invoice1, quantity: 1, unit_price: @item1.unit_price, status: 0 )
    @invoiceitem2 = InvoiceItem.create!(item: @item2, invoice: @invoice1, quantity: 2, unit_price: @item2.unit_price, status: 0 )
    @invoiceitem3 = InvoiceItem.create!(item: @item1, invoice: @invoice2, quantity: 1, unit_price: @item1.unit_price, status: 0 )
    @invoiceitem4 = InvoiceItem.create!(item: @item3, invoice: @invoice3, quantity: 1, unit_price: @item3.unit_price, status: 0 )
  end

  describe 'model methods' do
    describe '#item_name' do
      it 'returns the name of an invoice_item item' do
        expect(@invoiceitem1.item_name).to eq(@item1.name)
        expect(@invoiceitem2.item_name).to eq(@item2.name)
        expect(@invoiceitem3.item_name).to eq(@item1.name)
      end
    end

    describe '#biggest_discount' do
      it 'can find the biggest discount on an invoice item' do
        expect(@invoiceitem1.biggest_discount).to eq(@discount2)
        expect(@invoiceitem2.biggest_discount).to eq(@discount1)
      end
    end

    describe '#retail_price_total' do
      it 'can return the non-discounted invoice item total' do
        expect(@invoiceitem1.retail_price_total).to eq(2417)
        expect(@invoiceitem2.retail_price_total).to eq(3062)
      end
    end

    describe '#biggest_discount_percentage' do
      it 'can return the percentage from the biggest available discount' do
        expect(@invoiceitem1.biggest_discount_percentage).to eq(@discount2.percentage)
        expect(@invoiceitem2.biggest_discount_percentage).to eq(@discount1.percentage)
      end
    end

    describe '#discounted_price_total' do
      it 'can return the discounted invoice item total' do
        expect(@invoiceitem1.discounted_price_total).to eq(2054)
        expect(@invoiceitem2.discounted_price_total).to eq(2450)
      end
    end

    describe '#invoice_item_total' do
      it 'can return the invoice item total considering any discounts' do
        expect(@invoiceitem1.invoice_item_total).to eq(2054)
        expect(@invoiceitem2.invoice_item_total).to eq(2450)
        expect(@invoiceitem4.invoice_item_total).to eq(2100)
      end
    end
  end
end