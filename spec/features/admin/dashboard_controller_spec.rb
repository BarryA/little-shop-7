require "rails_helper"

RSpec.describe "the admin dashboard show" do
  
  # 19. Admin Dashboard
  it "displays the header" do
    # As an admin
    # When I visit the admin dashboard (/admin)
    visit "/admin/"
    # Then I see a header indicating that I am on the admin dashboard
    expect(page).to have_content("Admin Dashboard")
  end
end