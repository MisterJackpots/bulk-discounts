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

  it 'displays the percentage/quantity threshold of the bulk discount' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)

    within "#discount_info" do
      expect(page).to have_content(@discount1.percentage)
      expect(page).to have_content(@discount1.quantity_threshold)
      expect(page).to_not have_content(@discount2.percentage)
      expect(page).to_not have_content(@discount2.percentage)
    end
  end

  it 'has a link to edit the bulk discount' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)

    within "#discount_info" do
      expect(page).to have_link('Edit')
    end
  end

  it 'can direct merchant to discount edit page with current attributes populated' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)
    click_link('Edit')

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount1))
    expect(page).to have_field('Percentage off Item Price:', with: 20)
    expect(page).to have_field('Minimum Purchase Quantity:', with: 10)
  end

  it 'can update the bulk discount and redirect the discount show page' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)
    click_link('Edit')

    fill_in('Percentage off Item Price:', with: 35)
    fill_in('Minimum Purchase Quantity:', with: 20)
    
    click_button('Edit Discount')
    
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
    within "#discount_info" do
      expect(page).to have_content("35%")
      expect(page).to have_content("20")
    end
  end

  it 'will re-render the edit form if given invalid info' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)
    click_link('Edit')

    fill_in('Percentage off Item Price:', with: "a")
    fill_in('Minimum Purchase Quantity:', with: 20)
    
    click_button('Edit Discount')

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount1))
    expect(page).to have_field('Percentage off Item Price:', with: 20)
    expect(page).to have_field('Minimum Purchase Quantity:', with: 10)
    expect(page).to have_content("Invalid data, please try again")
  end
end