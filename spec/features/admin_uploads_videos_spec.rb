require "spec_helper"

feature "Admin uploads videos" do
  scenario "Admin successfully uploads a video" do
     admin = Fabricate(:admin)
    sign_in(admin)

    comedy = Fabricate(:category)

    visit new_admin_video_path
    fill_in "Title", with: "Friends"
    select comedy.title, from: "Category"
    fill_in "Description", with: "Good drama"
    attach_file "Large Cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small Cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.example.com/video.mp4"
    click_button "Add Video"
    expect_content("Video Friends has been created!")

    sign_out

    sign_in

    friends = Video.first
    visit video_path(friends)
    expect(page).to have_selector("img[src='/uploads/video/large_cover/#{friends.id}/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/video.mp4']")
  end
end