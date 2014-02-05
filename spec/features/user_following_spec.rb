require "spec_helper"

feature "User following" do
  given(:current_user) { Fabricate(:user) }
  given(:leader) { Fabricate(:user) }
  given(:category) { Fabricate(:category) }
  given(:video) { Fabricate(:video, category: category) }

  background do
    sign_in(current_user)
    Fabricate(:review, creator: leader, video: video)
  end

  scenario "user follows another user" do
    click_on_video_on_home_page(video)
    to_user_profile(leader)
    follow_user
    expect_content(leader.full_name)
  end

  scenario "user can not follow another user twice" do
    click_on_video_on_home_page(video)
    to_user_profile(leader)
    follow_user

    click_on_video_on_home_page(video)
    to_user_profile(leader)
    expect_link_not_to_be_seen("Follow")
  end

  def follow_user
    click_link "Follow"
  end

  def to_user_profile(user)
    click_link user.full_name
  end

  def expect_content(contenx_text)
    page.should have_content contenx_text
  end

  def expect_link_not_to_be_seen(link_text)
    page.should_not have_content link_text
  end

end