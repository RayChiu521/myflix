require 'spec_helper'

feature "User registration", { js: true, vcr: true } do
  background do
    visit register_path
  end

  scenario "with valid personal data and valid credit card" do
    fill_in_valid_personal_data
    fill_in_valid_credit_card

    click_on "Sign Up"

    expect_content("User was created")
  end

  scenario "with valid personal data and invalid credit card" do
    fill_in_valid_personal_data
    fill_in_invalid_personal_data

    click_on "Sign Up"

    expect_content("This card number looks invalid")
  end

  scenario "with valid personal data and declined card" do
    fill_in_valid_personal_data
    fill_in_declined_credit_card

    click_on "Sign Up"

    expect_content("Your card was declined")
  end

  scenario "with valid personal data and invalid security code" do
    fill_in_valid_personal_data
    fill_in_invalid_security_code

    click_on "Sign Up"

    expect_content("Your card's security code is invalid")
  end

  scenario "with invalid personal data and valid card" do
    fill_in_personal_data
    fill_in_valid_credit_card

    click_on "Sign Up"

    expect_content("Please fix the error below")
  end

  scenario "with invalid personal data and invalid card" do
    fill_in_invalid_personal_data
    fill_in_invalid_credit_card

    click_on "Sign Up"

    expect_content("This card number looks invalid")
  end

  scenario "with invalid personal data and declined card" do
    fill_in_invalid_personal_data
    fill_in_declined_credit_card

    click_on "Sign Up"

    expect_content("Please fix the error below")
  end

  scenario "with invalid personal data and invalid security code" do
    fill_in_invalid_personal_data
    fill_in_invalid_security_code

    click_on "Sign Up"

    expect_content("Your card's security code is invalid")
  end


  def fill_in_valid_personal_data
    fill_in_personal_data(email: "phoebe@example.com", password: "password", full_name: "Phoebe Buffay")
  end

  def fill_in_invalid_personal_data
    fill_in_personal_data
  end

  def fill_in_personal_data(options = {})
    fill_in "Email Address", with: options[:email] || ""
    fill_in "Password", with: options[:password] || ""
    fill_in "Full name", with: options[:full_name] || ""
  end

  def fill_in_valid_credit_card
    fill_in_credit_card(card: "4242424242424242")
  end

  def fill_in_invalid_credit_card
    fill_in_credit_card(card: "123")
  end

  def fill_in_declined_credit_card
    fill_in_credit_card(card: "4000000000000002")
  end

  def fill_in_invalid_security_code
    fill_in_credit_card(card: "4242424242424242", security_code: "99")
  end
end