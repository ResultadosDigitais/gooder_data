require 'gooder_data/configuration'
require 'gooder_data/api_client'
require 'gooder_data/session_id'


module GooderData

  class << self

    attr_accessor :configuration

    def configuration
      @configuration ||= GooderData::Configuration.new
    end

    def configure
      yield(configuration)
      GooderData::ApiClient.base_uri configuration.base_uri
    end

  end

end
