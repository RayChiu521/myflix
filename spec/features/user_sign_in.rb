require "spec_helper"

feature "User sign in" do
  given(:henryk) { Fabricate(:user, password: "password") }

  scenario "Signing in with correct credentials" do
    visit sign_in_path
    fill_in "Email Address", with: henryk.email
    fill_in "Password", with: henryk.password
    click_on "Sign in"
    expect(page).to have_content "You've logged in."
  end

  scenario "Signing in with incorrect credentials" do
    visit sign_in_path
    fill_in "Email Address", with: henryk.email
    fill_in "Password", with: "#{henryk.password}abc"
    click_on "Sign in"
    expect(page).to have_content "There's something wrong with your email or password."
  end
end