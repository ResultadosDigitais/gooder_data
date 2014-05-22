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


## Contributing

1. Fork it ( http://github.com/<my-github-username>/gooder_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
