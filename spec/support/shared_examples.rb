shared_examples "require sign in" do
  it "redirects to the sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "tokenable" do
  it "creating with token" do
    expect(object.token).to be_present
  end
end