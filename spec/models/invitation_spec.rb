require "spec_helper"

describe Invitation do

  it { should belong_to(:invitor) }

  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:recipient_email) }
  it { should validate_presence_of(:message) }

  it_should_behave_like "tokenable" do
    subject do
      monica = Fabricate(:user)
      invitation = Invitation.new(invitor: monica, recipient_name: "phoebe", recipient_email: "phoebe@example.com", message: "It's cool!")
      invitation.save
      invitation
    end
  end
end