def set_current_user(user = nil)
  session[:user_id] = (user || Fabricate(:user)).id
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


def click_on_video_on_home_page(video)
  visit home_path
  find("a[href='/videos/#{video.id}']").click
end