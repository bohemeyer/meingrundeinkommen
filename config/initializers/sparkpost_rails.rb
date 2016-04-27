SparkPostRails.configure do |c|
  c.api_key = '6ef3cc88fada326360f9ac98a0a320d2ce27267b'
  #c.campaign_id = 'YOUR-CAMPAIGN'
  c.html_content_only = true
  c.inline_css = true
  #c.ip_pool = "MY-POOL"
  #c.return_path = 'BOUNCE-EMAIL@YOUR-DOMAIN.COM'
  #c.sandbox = true
  #c.subaccount = "123"
  c.track_clicks = true
  c.track_opens = true
  c.transactional = true
end
