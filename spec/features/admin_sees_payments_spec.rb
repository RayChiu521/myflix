require "spec_helper"

feature "Admin sees payment" do

  let(:monica) { Fabricate(:user, full_name: 'Monica Geller', email: 'monica@example.com') }

  before do
    Fabricate(:payment, user: monica, amount: '999')
  end

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect_content '$9.99'
    expect_content monica.full_name
    expect_content monica.email
  end

  scenario "user cannot see payments" do
    sign_in
    visit admin_payments_path
    not_expect_content '$9.99'
    not_expect_content monica.full_name
    expect_content "You do not have access to that area!"
  end
end