SparkPostRails.configure do |c|
  c.api_key = '2b545f95aa2dc1d3a20bc58617b7d03e631630bb'
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
