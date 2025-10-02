require "rails_helper"

RSpec.describe "Auth", type: :request do
  def json
    JSON.parse(response.body)
  end

  describe "POST /api/v1/auth/register" do
    let(:endpoint) { "/api/v1/auth/register" }

    context "with valid params" do
      let(:params) { { name: "Jane", email: "jane@example.com", password: "password123" } }

      it "creates a user" do
        expect { post endpoint, params:, as: :json }.to change(User, :count).by(1)
      end

      context "response" do
        before { post endpoint, params:, as: :json }

        it "returns 201 Created" do
          expect(response).to have_http_status(:created)
          expect(response.media_type).to eq("application/json")
        end

        it "returns tokens + user object" do
          expect(json["access_token"]).to be_present
          expect(json["refresh_token"]).to be_present
          expect(json.dig("user", "email")).to eq("jane@example.com")
          expect(json.dig("user", "roles")).to be_an(Array)
          role_names = json["user"]["roles"].map { |r| r["name"] }
          expect(role_names).to include(Role::NAMES[:user])
        end
      end
    end

    context "with mixed-case email" do
      let(:endpoint) { "/api/v1/auth/register" }
      let(:params) { { name: "Jane", email: "JaNe@Example.com", password: "password123" } }

      before { post endpoint, params:, as: :json }

      it "downcases email in response and DB" do
        expect(json.dig("user", "email")).to eq("jane@example.com")
        expect(User.find_by(email: "jane@example.com")).to be_present
      end
    end

    context "with duplicate email" do
      before { User.create!(name: "Old", email: "dup@example.com", password: "pass123") }

      it "does not create a user" do
        expect {
          post "/api/v1/auth/register", params: { name: "New", email: "dup@example.com", password: "pass123" }, as: :json
        }.not_to change(User, :count)
      end

      it "responds with 422 Unprocessable Entity" do
        post "/api/v1/auth/register", params: { name: "New", email: "dup@example.com", password: "pass123" }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /api/v1/auth/login" do
    let(:endpoint) { "/api/v1/auth/login" }
    let!(:user)    { User.create!(name: "Joe", email: "joe@example.com", password: "password123") }

    context "with lower-case email" do
      before { post endpoint, params: { email: "joe@example.com", password: "password123" }, as: :json }

      it "responds with 200 OK" do
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("application/json")
      end

      it "returns access and refresh tokens" do
        expect(json["access_token"]).to be_present
        expect(json["refresh_token"]).to be_present
      end
    end

    context "with mixed-case email" do
      before { post endpoint, params: { email: "JoE@eXaMPle.cOm", password: "password123" }, as: :json }

      it "responds with 200 OK" do
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("application/json")
      end

      it "returns access and refresh tokens" do
        expect(json["access_token"]).to be_present
        expect(json["refresh_token"]).to be_present
      end
    end

    context "with invalid credentials" do
      before { post endpoint, params: { email: "joe@example.com", password: "wrong" }, as: :json }

      it "responds with 401 Unauthorized" do
        expect(response).to have_http_status(:unauthorized)
        expect(response.media_type).to eq("application/json")
      end

      it "returns an error message" do
        expect(json.dig("error", "detail")).to match(/Invalid/i)
      end
    end
  end

  describe "GET /api/v1/users/me" do
    let(:endpoint) { "/api/v1/users/me" }
    let!(:user)    { User.create!(name: "Mia", email: "mia@example.com", password: "password123") }
    let(:tokens)   { JwtService.issue_tokens_for(user) }

    context "when authorized" do
      before do
        user.add_role!(Role::NAMES[:user])
        get endpoint, headers: { "Authorization" => "Bearer #{tokens[:access_token]}" }
      end

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("application/json")
      end

      it "returns current user" do
        expect(json["email"]).to eq("mia@example.com")
      end
    end

    context "when missing token" do
      before { get endpoint }

      it "responds with 401 Unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
