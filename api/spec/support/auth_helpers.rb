module AuthHelpers
  def auth_headers_for(user = nil)
    user ||= FactoryBot.create(:user)
    tokens = JwtService.issue_tokens_for(user)
    { "Authorization" => "Bearer #{tokens[:access_token]}" }
  end
end
