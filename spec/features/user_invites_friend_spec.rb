require "spec_helper"

feature "User invites friends" do
  scenario "user successfully invites a friend and invitation is accepted", { js: true, vcr: true } do
    monica = Fabricate(:user)
    sign_in(monica)

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    friend_should_follow(monica)
    invitor_should_follow_friend(monica)

    clear_email
  end

  def invite_a_friend
    visit invitation_path
    fill_in "Friend's Name", with: "phoebe"
    fill_in "Friend's Email Address", with: "phoebe@example.com"
    fill_in "Invitation Message", with: "IT'S COOL!!"
    click_button "Send Invitation"

    sign_out
  end

  def friend_accepts_invitation
    open_email("phoebe@example.com")
    current_email.click_link("MyFLiX")

    fill_in "Password", with: "password"
    fill_in "Full name", with: "Phoebe Buffay"
    fill_in_credit_card(card: "4242424242424242")

    click_button "Sign Up"

    expect_content "User was created."
  end

  def friend_signs_in

    fill_in "Email Address", with: "phoebe@example.com"
    fill_in "Password", with: "password"

    click_button "Sign in"
  end

  def friend_should_follow(user)
    click_link "People"
    expect_content(user.full_name)

    sign_out
  end

  def invitor_should_follow_friend(user)
    sign_in(user)
    click_link "People"
    expect_content("Phoebe Buffay")
  end
end