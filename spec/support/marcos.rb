def set_current_user(user = nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(admin = nil)
  set_current_user(admin || Fabricate(:admin))
end

def get_current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(user=nil)
  user = Fabricate(:user) if user.nil?
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_on "Sign in"
end

def sign_out
  visit sign_out_path
end

def click_on_video_on_home_page(video)
  visit home_path
  find("a[href='/videos/#{video.id}']").click
end

def expect_content(contenx_text)
  page.should have_content contenx_text
end

def fill_in_credit_card
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  select "12 - December", from: "date_month"
  select "#{(DateTime.now.year + 1).to_s}", from: "date_year"
end