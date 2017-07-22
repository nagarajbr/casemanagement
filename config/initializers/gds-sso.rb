GDS::SSO.config do |config|
  config.user_model   = 'User'

  # set up ID and Secret in a way which doesn't require it to be checked in to source control...
  config.oauth_id     = 'd58acdbdcf8b1a9718389e44e2f58bf80be6d9792b56af4646921d078b165dd0' #ENV['OAUTH_ID']
  config.oauth_secret = '170e154e91a1ad836d499d7959576c1c99c124abeeb0a2864ad7cde570a6539f' # ENV['OAUTH_SECRET']

  # optional config for location of signonotron2
  config.oauth_root_url = 'http://arwins-sso.state.ar.us/'
end

