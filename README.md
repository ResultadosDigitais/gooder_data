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
gd = GooderData.new
gd.connect!("my.gd.client@email.com", "my_password")
gd.project_id = "myprojectid"
execution_id = gd.execute_process("process_id", "my_project_name/graph/graph_name.grf")
```

### Embedding GoodData Dashboard iFrame with SSO
```
session_id = GooderData.SessionId.new("my.app.user@email.com").to_url

iframe_url = "https://secure.gooddata.com/gdc/account/customerlogin?sessionId=#{ session_id }&serverURL=#{ my_sso_provider }&targetURL=#{ target_gd_dashboard_url }"

<iframe src="<% iframe_url %>"/>
```

### Configurations and default values
```
GooderData.configure do |c|
  self.signature_expiration_in_seconds = 3600 # 1 hour
  # default = 36 hours
  # 10 min < expiration < 36 hours; https://developer.gooddata.com/article/gooddata-pgp-single-sign-on

  self.default_project_id = "my-prioject-id"
  # default nil
  # if not configured nor given programmatically it will raise error

  self.default_user = "admin@domain.com"
  # default nil
  # if not configured nor given programmatically it will raise error

  self.default_user_password = "mY-h4RD p@55w0rD_"
  # default nil
  # if not configured nor given programmatically it will raise error
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/gooder_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
