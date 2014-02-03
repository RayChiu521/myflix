require "spec_helper"

feature "My Queue" do
  given(:current_user) { Fabricate(:user) }
  given(:category1) { Fabricate(:category) }

  background do
    sign_in(current_user)
  end

  scenario "user adds a video to my queue and it's not allow add it again in video show page" do
    video = Fabricate(:video, category: category1)

    visit videos_path

    click_link("video_#{video.id}")
    page.should have_content video.title

    click_link("+ My Queue")
    page.should have_content "My Queue"
    page.should have_content video.title

    click_link("Videos")

    click_link("video_#{video.id}")
    page.should_not have_content "+ My Queue"
  end

  scenario "user reorders videos in my queue" do
    video1 = Fabricate(:video, category: category1)
    video2 = Fabricate(:video, category: category1)
    queue_item1 = Fabricate(:queue_item, creator: current_user, video: video1, position: 1)
    queue_item2 = Fabricate(:queue_item, creator: current_user, video: video2, position: 2)

    visit my_queue_path
    find("#queue_items_#{queue_item1.id}_position").set("3")
    click_button("Update Instant Queue")

    find("#queue_items_#{queue_item1.id}_position").value.should == "2"
    find("#queue_items_#{queue_item2.id}_position").value.should == "1"
  end
end