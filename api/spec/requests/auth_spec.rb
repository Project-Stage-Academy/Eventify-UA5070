require "rails_helper"

RSpec.describe "Auth", type: :request do
  before do
    Role.find_or_create_by!(name: "USER")
    Role.find_or_create_by!(name: "ADMIN")
  end

  describe "POST /auth/register" do
    it "creates a user and returns tokens + user object" do
      params = { name: "Jane", email: "jane@example.com", password: "password123" }
      post "/auth/register", params: params, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["access_token"]).to be_present
      expect(json["refresh_token"]).to be_present
      expect(json["user"]["email"]).to eq("jane@example.com")
      expect(json["user"]["roles"]).to be_an(Array)
      expect(json["user"]["roles"].map { |r| r["name"] }).to include("USER")
    end

    it "fails on duplicate email" do
      User.create!(name: "Old", email: "dup@example.com", password: "pass123")
      post "/auth/register", params: { name: "New", email: "dup@example.com", password: "pass123" }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "POST /auth/login" do
    let!(:user) { User.create!(name: "Joe", email: "joe@example.com", password: "password123") }

    it "returns tokens for valid credentials" do
      post "/auth/login", params: { email: "joe@example.com", password: "password123" }, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["access_token"]).to be_present
      expect(json["refresh_token"]).to be_present
    end

    it "rejects invalid email/password" do
      post "/auth/login", params: { email: "joe@example.com", password: "wrong" }, as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json["error"]).to match(/Invalid/)
    end
  end

  describe "GET /user/me" do
    let!(:user) { User.create!(name: "Mia", email: "mia@example.com", password: "password123") }

    it "returns current user when authorized" do
      user.roles << Role.find_by!(name: "USER")

      tokens = JwtService.issue_tokens_for(user)
      get "/user/me", headers: { "Authorization" => "Bearer #{tokens[:access_token]}" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["email"]).to eq("mia@example.com")
    end

    it "rejects missing token" do
      get "/user/me"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
