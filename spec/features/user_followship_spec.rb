require "spec_helper"

feature "User followship" do
  given(:current_user) { Fabricate(:user) }
  given(:leader) { Fabricate(:user) }
  given(:category) { Fabricate(:category) }
  given(:video) { Fabricate(:video, category: category) }

  background do
    sign_in(current_user)
  end

  scenario "user follows another user" do
      to_profile(leader)
      follow_user
      expect_content(leader.full_name)
  end

  scenario "user not allow follow a user twice" do
    to_profile(leader)
    follow_user

    to_profile(leader)
    expect_link_not_to_be_seen("Follow")
  end

  def follow_user
    click_link "Follow"
  end

  def to_profile(user)
    visit user_path(user)
  end

  def expect_content(contenx_text)
    page.should have_content contenx_text
  end

  def expect_link_not_to_be_seen(link_text)
    page.should_not have_content link_text
  end

end