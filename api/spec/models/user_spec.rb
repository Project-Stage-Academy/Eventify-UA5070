require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    context "when blank" do
      subject(:user) { build(:user, name: nil, email: nil, password: nil) }

      before { user.validate }

      it "adds presence/length errors" do
        expect(user).to be_invalid
        expect(user.errors[:name]).to be_present
        expect(user.errors[:email]).to be_present
        expect(user.errors[:password]).to be_present
      end
    end

    context "email format & uniqueness" do
      let!(:existing) { create(:user, email: "a@example.com") }
      subject(:user) { build(:user, email: "A@Example.com") }

      before { user.validate }

      it "normalizes and rejects duplicate email" do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("has already been taken")
      end
    end
  end

  describe "#authenticate" do
    let!(:user) { create(:user, password: "secret123") }

    it "authenticates with the correct password" do
      expect(user.authenticate("secret123")).to eq(user)
    end

    it "fails authentication with a wrong password" do
      expect(user.authenticate("wrongpass")).to be_falsey
    end
  end
end
