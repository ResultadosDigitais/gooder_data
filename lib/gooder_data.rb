require 'gooder_data/configuration'
require 'gooder_data/api_client'
require 'gooder_data/session_id'
require 'gooder_data/sso'
require 'gooder_data/organization'
require 'gooder_data/project'
require 'gooder_data/errors'
require 'gooder_data/utils/json_hash_array'
require 'gooder_data/utils/json_hash_object'

require 'gooder_data/project/role'
require 'gooder_data/project/query_attribute'
require 'gooder_data/project/query_value'
require 'gooder_data/project/query'
require 'gooder_data/project/dashboard'
require 'gooder_data/project/status'
require 'gooder_data/project/report'
require 'gooder_data/project/raw_report'
require 'gooder_data/project/report/data'
require 'gooder_data/project/report/series'
require 'gooder_data/project/report/x_axis'
require 'active_support/core_ext/hash/indifferent_access'

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

# TODO Mats use JsonHashObject for method return
