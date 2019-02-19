RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.run_all_when_everything_filtered = true
  c.filter_run :focus
  c.order = 'random'
end

require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
end

require 'gooder_data'

def test_options(customization = {})
  {
    organization_name: 'my_domain',
    user: 'user@example.org',
    user_password: 'my_password',
    sso_authentication_provider: 'my.auth.provider',
    sso_signer_email: 'user@example.org',
    sso_signer_password: 'my_sso_password'
  }.merge(customization)
end
