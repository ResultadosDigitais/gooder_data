# GooderData

GoodData API ruby client

[![Code Climate](https://codeclimate.com/github/ResultadosDigitais/gooder_data/badges/gpa.svg)](https://codeclimate.com/github/ResultadosDigitais/gooder_data) [![Test Coverage](https://codeclimate.com/github/ResultadosDigitais/gooder_data/badges/coverage.svg)](https://codeclimate.com/github/ResultadosDigitais/gooder_data) [![Build Status](https://secure.travis-ci.org/ResultadosDigitais/gooder_data.png)](http://travis-ci.org/ResultadosDigitais/gooder_data)


## Installation

Add this line to your application's Gemfile:

    gem 'gooder_data'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gooder_data

## Usage

### Execute a process
```ruby
project = GooderData::Project.new(project_id: "#{ project_id }")
process_id = project.execute_process("#{ process_id }", "#{ my_project_name/graph/graph_name.grf }")
```

### Embedding GoodData Dashboard iFrame with SSO
```ruby
# Controller
dashboard_url = GooderData::Project::Dashboard.new('my-dashboard-id', project_id: 'my-project-id').url
iframe_url = GooderData::SSO.new("my.app.user@email.com", organization_name: 'my-organization').url(dashboard_url)

# index.html.erb
<iframe src="<%= iframe_url -%>"/>
```

### Creating and assigning Mandatory User Filter (MUF)
```ruby
project = GooderData::Project.new(project_id: 'my-project-id')

attribute = project.query_attributes.find(identifier: 'my_dataset.my_attribute')
values = attribute.values.where { |value| value.title.to_i > 5 }
query = GooderData::Project::Query.new(attribute).in(*values)

filter_id = project.create_mandatory_user_filter('My filter name', query)

project.bind_mandatory_user_filter(filter_id, 'my-user-profile-id')
```

### GoodData API Client and using non implemented api calls
```ruby
client = GooderData::ApiClient.new
client.connect!("my.gd.project.admin.user@email.com", "my_password")
client.api_to("execute process and return the execution details link") do |options|
  post("/projects/#{ project_id }/dataload/processes/#{ process_id }/executions", {
    execution: {
      executable: executable_graph_path
    }
  })
end.that_responds do |response|
  response['executionTask']['links']['details'] rescue ''
end
```
[Link for GoodData Api](http://docs.gooddata.apiary.io/#get-%2Fgdc%2Fprojects%2F%7Bproject-id%7D%2Fdataload%2Fprocesses%2F%7Bprocess-id%7D%2Fexecutions%7B%3Foffset%2Climit%7D) of the implementation above

### Configurations and default values
```ruby
GooderData.configure do |c|
  # default = 36 hours
  # 10 min < expiration < 36 hours;
  # https://developer.gooddata.com/article/gooddata-pgp-single-sign-on
  c.signature_expiration_in_seconds = 3600 # 1 hour

  # default nil, :required
  c.project_id = "my-prioject-id"

  # default nil
  c.user_email = "gd.project.admin.user@domain.com"

  # default nil, :required
  c.user_password = "mY-h4RD p@55w0rD_"

  # default nil
  # gets first GPG signature if nil
  c.sso_signer_email = "pgp.secret.signature.email@domain.com"

  # default nil
  # no passphrase signature if nil
  c.sso_signer_password = 'secretpassword'
end
```

## Contributing

1. Fork it ( http://github.com/ResultadosDigitais/gooder_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Stage your changes (`git add -A`)
3. Commit your changes (`git commit`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
