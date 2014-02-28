require 'spec_helper'

feature "User registration", { js: true, vcr: true } do
  background do
    visit register_path
  end

  scenario "user inputs valid personal data and valid credit card" do
    fill_in_personal_data("phoebe@example")
    fill_in_credit_card(card: "4242424242424242")

    click_on "Sign Up"

    expect_content("User was created")
  end

  scenario "user inputs valid personal data and declined card" do
    fill_in_personal_data("phoebe@example")
    fill_in_credit_card(card: "4000000000000002")

    click_on "Sign Up"

    expect_content("Your card was declined.")
  end

  scenario "user inputs valid personal data and incorrect card number" do
    fill_in_personal_data("phoebe@example")
    fill_in_credit_card(card: "4242424242424241")

    click_on "Sign Up"

    expect_content("Your card number is incorrect")
  end

  scenario "user inputs valid personal data and invalid security code" do
    fill_in_personal_data("phoebe@example")
    fill_in_credit_card(card: "4242424242424242", security_code: "99")

    click_on "Sign Up"

    expect_content("Your card's security code is invalid")
  end

  scenario "user inputs invalid personal data" do
    fill_in_personal_data("")
    fill_in_credit_card(card: "4242424242424242")

    click_on "Sign Up"

    expect_content("Please fix the error below")
  end

  def fill_in_personal_data(email)
    fill_in "Email Address", with: email
    fill_in "Password", with: "password"
    fill_in "Full name", with: "Phoebe Buffay"
  end
end