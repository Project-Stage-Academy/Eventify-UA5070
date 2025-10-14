Rswag::Api.configure do |c|
  c.openapi_root = File.join(Rails.root, "swagger")
  c.swagger_filter = lambda do |swagger, env|
    swagger["servers"] = [ { "url" => "http://localhost:3000" } ]
  end
end
