Rswag::Ui.configure do |c|
  path = SWAGGER_PATH
  title = "API V1 Docs"

  if c.respond_to?(:openapi_endpoint)
    c.openapi_endpoint path, title
  else
    c.swagger_endpoint path, title
  end
end
