Rswag::Ui.configure do |c|
  cfg = Rails.application.config_for(:swagger)
  Array(cfg["ui_endpoints"]).each do |ep|
    c.swagger_endpoint ep["path"], ep["title"]
  end
end
