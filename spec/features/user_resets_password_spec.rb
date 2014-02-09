require "spec_helper"

feature "User resets password" do
  scenario "user successful resets the password" do
    monica = Fabricate(:user, password: "old_password")

    visit sign_in_path
    click_link "Forget Password?"

    fill_in "Email Address", with: monica.email
    click_button "Send Email"

    open_email(monica.email)
    current_email.click_link("Reset My Password")
    expect_content("Reset Your Password")

    fill_in "New Password", with: "new_password"
    click_button "Reset Password"
    expect_content("Your password has been changed.")

    fill_in "Email Address", with: monica.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"
    expect_content("Welcome, #{monica.full_name}")
  end
end