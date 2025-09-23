require "rails_helper"

RSpec.describe User, type: :model do
  it "validates presence and lengths" do
    user = User.new

    expect(user).to be_invalid
    expect(user.errors[:name]).to be_present
    expect(user.errors[:email]).to be_present
    expect(user.errors[:password_digest]).to be_present
  end

  it "validates email format & uniqueness" do
    User.create!(name: "A", email: "a@example.com", password: "secret123")
    u2 = User.new(name: "B", email: "A@Example.com", password: "secret123")

    expect(u2).to be_invalid
    expect(u2.errors[:email]).to include("has already been taken")
  end

  it "hashes password via has_secure_password" do
    u = User.create!(name: "A", email: "x@y.com", password: "secret123")

    expect(u.authenticate("secret123")).to eq(u)
    expect(u.authenticate("nope")).to be_falsey
  end
end
