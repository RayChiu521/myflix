require "spec_helper"

feature "user interacts with the queue" do
  given(:current_user) { Fabricate(:user) }
  given(:category1) { Fabricate(:category) }

  background do
    sign_in(current_user)
  end

  scenario "user adds a video to my queue and it's not allow add it again in video show page" do

    video = Fabricate(:video, category: category1)

    add_video_to_queue(video)
    expect_video_to_be_in_queue(video)

    visit video_path(video)
    expect_link_not_to_be_seen("+ My Queue")
  end

  scenario "user reorders videos in my queue" do
    video1 = Fabricate(:video, category: category1)
    video2 = Fabricate(:video, category: category1)
    video3 = Fabricate(:video, category: category1)

    add_video_to_queue(video1)
    add_video_to_queue(video2)
    add_video_to_queue(video3)

    set_video_position(video1, 3)
    set_video_position(video2, 1)
    set_video_position(video3, 2)

    update_queue

    expect_video_position(video2, "1")
    expect_video_position(video3, "2")
    expect_video_position(video1, "3")
  end

  def expect_video_to_be_in_queue(video)
    visit my_queue_path
    page.should have_content video.title
  end

  def expect_link_not_to_be_seen(link_text)
    page.should_not have_content link_text
  end

  def add_video_to_queue(video)
    click_on_video_on_home_page(video)
    click_link "+ My Queue"
  end

  def update_queue
    click_button("Update Instant Queue")
  end

  def expect_content(content_text)
    page.should have_content content_text
  end

  def video_input_in_queue(video)
    find(:xpath, "//tr[contains(., '#{video.title}')]//input[@type='text']")
  end

  def set_video_position(video, position)
    video_input_in_queue(video).set(position)
  end

  def expect_video_position(video, position)
    expect(video_input_in_queue(video).value).to eq(position)
  end
end