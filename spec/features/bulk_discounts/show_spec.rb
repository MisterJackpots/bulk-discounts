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
  # As a merchant
  # When I visit my bulk discount show page
  # Then I see a link to edit the bulk discount
  # When I click this link
  # Then I am taken to a new page with a form to edit the discount
  # And I see that the discounts current attributes are pre-poluated in the form
  # When I change any/all of the information and click submit
  # Then I am redirected to the bulk discount's show page
  # And I see that the discount's attributes have been updated
  it 'has a link to edit the bulk discount' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)

    within "#discount_info" do
      expect(page).to have_link('Edit')
    end
  end

  it 'can direct merchant to discount edit page with current attributes populated' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)
    click_link('Edit')

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount))
    expect(page).to have_field('Percentage off Item Price')
    expect(page).to have_field('Minimum Purchase Quantity')
    expect(page).to have_content(@discount1.percentage)
    expect(page).to have_content(@discount1.quantity_threshold)
  end

  it 'can update the bulk discount and redirect the discount show page' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)
    click_link('Edit')

    fill_in('Percentage off Item Price', with: 35)
    fill_in('Minimum Purchase Quantity', with: 20)
    click_button('Create Discount')

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
    within "#discount_info" do
      expect(@discount1.percentage).to match(35)
      expect(@discount1.quantity_threshold).to match(20)
    end
  end
end