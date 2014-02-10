require "spec_helper"

feature "User invites friends" do
  scenario "user successful invites a friend to register our website" do
    monica = Fabricate(:user)
    sign_in(monica)

    visit invite_friend_path
    fill_in "Friend's Name", with: "phoebe"
    fill_in "Friend's Email Address", with: "phoebe@example.com"
    fill_in "Invitation Message", with: "IT'S COOL!!"
    click_button "Send Invitation"

    open_email("phoebe@example.com")
    current_email.click_link("MyFLiX")
    expect_content("Register")

    fill_in "Password", with: "password"
    fill_in "Full name", with: "Phoebe Buffay"
    click_button "Sign Up"
    expect_content("User was created.")

  end
end