require 'rails_helper'

RSpec.describe 'the Bulk Discounts Index page' do
  before :each do
    @merchant1 = Merchant.create!(name: "Billy's Baby Book Barn")
    @merchant2 = Merchant.create!(name: "Candy's Child Compendium Collection")
    @discount1 = BulkDiscount.create!(percentage: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage: 30, quantity_threshold: 15, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage: 10, quantity_threshold: 5, merchant_id: @merchant2.id)
    @discount4 = BulkDiscount.create!(percentage: 20, quantity_threshold: 10, merchant_id: @merchant2.id)
    @item1 = @merchant1.items.create!(name: "Learn to Count, Dummy!", description: "Educational Children's Book", unit_price: 2400)
    @item2 = @merchant1.items.create!(name: "Go to Sleep Please, Mommy Just Wants to Watch Leno", description: "Baby Book", unit_price: 1550)
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
    @invoiceitem5 = InvoiceItem.create!(item: @item3, invoice: @invoice1, quantity: 1, unit_price: @item1.unit_price, status: 0 )
  end
  # As a merchant
  # When I visit my bulk discount show page
  # Then I see the bulk discount's quantity threshold and percentage discount
  it 'displays the percentage/quantity threshold of the bulk discount' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)

    within "#discount_info" do
      expect(page).to have_content(@discount1.percentage)
      expect(page).to have_content(@discount1.quantity_threshold)
      expect(page).to_not have_content(@discount2.percentage)
      expect(page).to_not have_content(@discount2.percentage)
    end
  end
end