# GooderData

GoodData API ruby client

## Installation

Add this line to your application's Gemfile:

    gem 'gooder_data'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gooder_data

## Usage

### GoodData API Client
```
client = GooderData::ApiClient.new
client.connect!("my.gd.project.admin.user@email.com", "my_password")
client.project_id = "myprojectid"
execution_id = client.execute_process("process_id", "my_project_name/graph/graph_name.grf")
```

### Embedding GoodData Dashboard iFrame with SSO
```
dashboard_url = GooderData::Dashboard.new('my-dashboard-id', project_id: 'my-project-id').url
iframe_url = GooderData::SSO.new("my.app.user@email.com", organization_name: 'my-organization').url(dashboard_url)
<iframe src="<% iframe_url %>"/>
```

### Configurations and default values
```
GooderData.configure do |c|
  c.signature_expiration_in_seconds = 3600 # 1 hour
  # default = 36 hours
  # 10 min < expiration < 36 hours; https://developer.gooddata.com/article/gooddata-pgp-single-sign-on

  c.project_id = "my-prioject-id"
  # default nil, :required

  c.user_email = "gd.project.admin.user@domain.com"
  # default nil

  c.user_password = "mY-h4RD p@55w0rD_"
  # default nil, :required

  c.sso_signer_email = "pgp.secret.signature.email@domain.com"
  # default nil
  # gets first GPG signature if nil

  c.sso_signer_password = 'secretpassword'
  # default nil
  # no passphrase signature if nil
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/gooder_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
