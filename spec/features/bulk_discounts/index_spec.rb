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

  it 'has a link on the Merchant dashboard that re-directs to the page' do
    visit "/merchants/#{@merchant1.id}"

    expect(page).to have_link('Discounts Offered')
    
    click_link('Discounts Offered')

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")
  end

  it 'displays percentage/quantity threshold for all bulk discounts' do
    visit "/merchants/#{@merchant1.id}/bulk_discounts"

    within "#discount_info_#{@discount1.id}" do
      expect(page).to have_content("#{@discount1.percentage}% off")
      expect(page).to have_content("#{@discount1.quantity_threshold} items or more")
    end

    within "#discount_info_#{@discount2.id}" do
      expect(page).to have_content("#{@discount2.percentage}% off")
      expect(page).to have_content("#{@discount2.quantity_threshold} items or more")
    end
  end

  it 'has a link that re-directs to the show page for each discount' do
    visit "/merchants/#{@merchant1.id}/bulk_discounts"

    within "#discount_info_#{@discount1.id}" do
      expect(page).to have_link('More Info')
      click_link('More Info')
      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}")
    end

    visit "/merchants/#{@merchant1.id}/bulk_discounts"
    within "#discount_info_#{@discount2.id}" do
      expect(page).to have_link('More Info')
      click_link('More Info')
      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@discount2.id}")
    end
  end

  it 'has a link to create a new discount' do
    visit "/merchants/#{@merchant1.id}/bulk_discounts"

    expect(page).to have_link('Create a New Discount')
    click_link('Create a New Discount')
    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
  end

  it 'can create a new discount for the Merchant' do
    visit "/merchants/#{@merchant1.id}/bulk_discounts"

    click_link('Create a New Discount')

    fill_in('Percentage off Item Price', with: 35)
    fill_in('Minimum Purchase Quantity', with: 20)
    click_button('Create Discount')
 
    new_discount = BulkDiscount.last

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")

    within "#discount_info_#{new_discount.id}" do
      expect(page).to have_content("#{new_discount.percentage}% off")
      expect(page).to have_content("#{new_discount.quantity_threshold} items or more")
      expect(page).to have_link('More Info')
    end
  end
  
  it 'has a link next to each discount to delete the discount' do
    visit "/merchants/#{@merchant1.id}/bulk_discounts"

    within "#discount_info_#{@discount1.id}" do
      expect(page).to have_link('Delete')
    end
    within "#discount_info_#{@discount2.id}" do
      expect(page).to have_link('Delete')
    end
  end

  it 'can delete a discount' do
    visit "/merchants/#{@merchant1.id}/bulk_discounts"

    within "#discount_info_#{@discount2.id}" do
      click_link('Delete')
    end

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")
    expect(page).to_not have_content(@discount2.percentage)
    expect(page).to_not have_content(@discount2.quantity_threshold)
  end
end