require 'rails_helper'

RSpec.describe 'the merchant invoices show page' do
  before :each do
    @merchant1 = Merchant.create!(name: "Billy's Baby Book Barn")
    @merchant2 = Merchant.create!(name: "Candy's Child Compendium Collection")
    @discount1 = BulkDiscount.create!(percentage: 20, quantity_threshold: 2, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage: 15, quantity_threshold: 2, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage: 30, quantity_threshold: 3, merchant_id: @merchant1.id)
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

  it 'displays the id/status/date/customer name related to the invoice' do
    visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

    expect(page).to have_content("Invoice ##{@invoice1.id}")
    expect(page).to have_content("Status: in progress")
    expect(page).to have_content("Created on: #{@invoice1.created_at.strftime('%A, %B%e, %Y')}")
    expect(page).to have_content("#{@mary.first_name} #{@mary.last_name}")
  end

  it 'display name/quantity/price/status for all invoice items' do
    visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

    within "#invoice_item_#{@invoiceitem1.id}" do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@invoiceitem1.quantity)
      expect(page).to have_content("$24.00")
      expect(page).to have_content(@invoiceitem1.status)
    end

    within "#invoice_item_#{@invoiceitem2.id}" do
      expect(page).to have_content(@item2.name)
      expect(page).to have_content(@invoiceitem2.quantity)
      expect(page).to have_content("15.50")
      expect(page).to have_content(@invoiceitem2.status)
    end
  end

  it 'displays the total revenue for items sold on this invoice' do
    visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

    expect(page).to have_content("Total Revenue: $55.00")
  end

  it 'displays the invoice item current status as a select field' do
    visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

    within "#invoice_item_#{@invoiceitem1.id}" do
      expect(page).to have_selector('#invoice_item_status')
      expect(page).to have_content('pending')
      expect(page).to have_button('Update Item Status')
    end

    within "#invoice_item_#{@invoiceitem2.id}" do
      expect(page).to have_selector('#invoice_item_status')
      expect(page).to have_content('pending')
      expect(page).to have_button('Update Item Status')
    end
  end

  it 'can update the status of an invoice item' do
    visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

    within "#invoice_item_#{@invoiceitem1.id}" do
      page.select('packaged', from: :invoice_item_status)
      click_button('Update Item Status')

      expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}")
      expect(page).to have_content(@invoiceitem1.status)
    end
  end

  it 'displays the total revenue for items sold on this invoice' do
    visit merchant_invoice_path(@merchant1, @invoice1)
    
    expect(page).to have_content("Discounted Revenue: $48.80")
  end

  it 'has a link to the bulk discount show page next to an invoice item, if applicable' do
    visit merchant_invoice_path(@merchant1, @invoice1)

    within "#invoice_item_#{@invoiceitem1.id}" do
      expect(page).to_not have_link('Discount Applied')
    end
    
    within "#invoice_item_#{@invoiceitem2.id}" do
      expect(page).to have_link('Discount Applied')
      click_link('Discount Applied')
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
    end
  end

  it 'displays the total for an invoice item based on unit price, quantity, and discount' do
    visit merchant_invoice_path(@merchant1, @invoice1)

    within "#invoice_item_#{@invoiceitem2.id}" do
      expect(page).to have_content("$24.80")
    end
  end
end