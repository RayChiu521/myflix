require "spec_helper"

feature "User sign in" do
  given(:henryk) { Fabricate(:user) }

  scenario "Signing in with correct credentials" do
    sign_in(henryk)
    expect_content(henryk.full_name)
  end

  scenario "Signing in with incorrect credentials" do
    visit sign_in_path
    fill_in "Email Address", with: henryk.email
    fill_in "Password", with: "#{henryk.password}abc"
    click_on "Sign in"
    expect_content("There's something wrong with your email or password.")
  end
end