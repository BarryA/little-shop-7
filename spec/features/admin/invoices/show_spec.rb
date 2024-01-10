require "rails_helper"


RSpec.describe "the admin invoices show" do
  before :each do
    @test_customer = Customer.create!(first_name: "Test", last_name: "Customer")
    @merchant = Merchant.create!(name: "Test Merchant")
    @item = Item.create!(name: "Test Item", description: "Test Description", unit_price: 100, merchant: @merchant)

    @incomplete_invoice1 = Invoice.create!(customer: @test_customer, created_at: 5.days.ago, status: "in progress")
    InvoiceItem.create!(invoice: @incomplete_invoice1, item: @item, quantity: 5, unit_price: 100, status: "packaged")
  end

  it "displays the correct information for an invoice" do
    visit admin_invoice_path(@incomplete_invoice1)

    expect(page).to have_content(@incomplete_invoice1.id)
    expect(page).to have_content(@incomplete_invoice1.status)

    formatted_date = @incomplete_invoice1.created_at.strftime("%A, %B %d, %Y")
    expect(page).to have_content(formatted_date)

    expect(page).to have_content(@incomplete_invoice1.customer.first_name)
    expect(page).to have_content(@incomplete_invoice1.customer.last_name)
  end

  it "displays invoice item data on a table" do
    visit admin_invoice_path(@incomplete_invoice1)

    within "table" do
      expect(page).to have_content(@item.name)
      expect(page).to have_content("5")
      expect(page).to have_content("$1.00")
      expect(page).to have_content("Packaged")
    end
  end

  it "displays the total invoice revenue" do
    visit admin_invoice_path(@incomplete_invoice1)
    
    total_invoice_revenue = number_to_currency(@incomplete_invoice1.total_revenue / 100.0)
    expect(page).to have_content("Total Revenue: #{total_invoice_revenue}")
  end
end