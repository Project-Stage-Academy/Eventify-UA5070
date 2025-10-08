require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    context "when blank" do
      subject(:user) { described_class.new }

      before { user.validate }

      it "adds presence/length errors" do
        expect(user).to be_invalid
        expect(user.errors[:name]).to be_present
        expect(user.errors[:email]).to be_present
        expect(user.errors[:password]).to be_present
      end
    end

    context "email format & uniqueness" do
      let!(:existing) do
        described_class.create!(name: "A", email: "a@example.com", password: "secret123")
      end

      subject(:user) do
        described_class.new(name: "B", email: "A@Example.com", password: "secret123")
      end

      before { user.validate }

      it "normalizes and rejects duplicate email" do
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("has already been taken")
      end
    end

    describe "#authenticate" do
      let!(:user) { described_class.create!(name: "A", email: "x@y.com", password: "secret123") }

      it "authenticates with the correct password" do
        expect(user.authenticate("secret123")).to eq(user)
      end

      it "fails authentication with a wrong password" do
        expect(user.authenticate("secret234")).to be_falsey
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:user_roles) }
    it { is_expected.to have_many(:roles).through(:user_roles) }

    it { is_expected.to have_many(:event_members) }
    it { is_expected.to have_many(:joined_events).through(:event_members) }
  end
end
