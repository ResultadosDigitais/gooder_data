require 'httparty'
require 'json'

module GooderData

  class ApiClient
    include HTTParty

    BAD_REQUEST = 400
    NOT_FOUND = 404
    UNAUTHORIZED = 401
    STILL_PROCESSING = 202
    NO_CONTENT = 204

    STATUS_WAIT = 'WAIT'

    def initialize(options = {})
      @super_secure_token = ""
      @temp_token = ""
      @options = GooderData.configuration.merge(options)
      self.class.base_uri(@options.require(:base_uri))
    end

    def super_secure_token=(super_secure_token)
      @super_secure_token = super_secure_token
    end

    def api_token=(api_token)
      @temp_token = api_token
    end

    def connect!(user = options[:user], password = options[:user_password])
      login!(user, password)
      api_token!
      self
    end

    def login!(user, password)
      self.super_secure_token = login(user, password)
    end

    def login(user, password)
      api_to("login the user '#{ user }'", :no_validations) do
        response = post("/account/login", {
          postUserLogin: {
            login: user,
            password: password,
            remember: 1
          }
        })
        raise "wrong user or password for user #{ user }" if response.code == UNAUTHORIZED
        response
      end.that_responds do |response|
        extract_cookie(response, 'GDCAuthSST')
      end
    end

    def api_token!
      self.api_token = api_token
    end

    def api_token
      api_to("get api_token", :needs_login) do
        get("/account/token")
      end.that_responds do |response|
        extract_cookie(response, 'GDCAuthTT')
      end
    end

    def api_to(description, pre_validation = :needs_api_token)
      send(pre_validation)
      response = yield options
      validate(response, "could not #{ description }")
    end

    def retry_api_to(description, pre_validation = :needs_api_token, &api_call_block)
      response = nil
      (0..options.require(:max_retries)).each do
        response = api_to(description, pre_validation, &api_call_block)
        break unless processing?(response)
        puts "Retrying #{description}: #{response.code}: #{response.task_status}"
        sleep options.require(:retry_delay_in_seconds).to_f
      end
      response
    end

    def post(path, data)
      options = basic_options
      options[:headers]["Content-Type"] = "application/json"
      options[:body] = data.to_json
      send_request(:post, path, options)
    end

    def get(path)
      send_request(:get, path)
    end

    def options
      @options
    end

    private

    def processing?(response)
      response.processing?
    end

    def to_json_hash_array(response, api_class, *array_path)
      elements = try_hash_chain(response, *array_path) || []
      JsonHashArray.from_haw_json(api_class, elements, options)
    end

    def no_validations; end

    def validate_api_token
      validate_login
      raise "api token is required at this point: please inform the api_token (temporary token - TT) or call api_token! first" if @temp_token.to_s.empty?
    end
    alias_method :needs_api_token, :validate_api_token

    def validate_login
      raise "login is required at this point: please inform the super_secure_token (SST) or call login! first" if @super_secure_token.to_s.empty?
    end
    alias_method :needs_login, :validate_login

    def validate(response, error_message)
      raise error_class(response), "#{ error_message }: #{ error_message(response) || response.parsed_response }" unless success?(response)
      response
    end

    def error_class(response)
      case response.code
      when BAD_REQUEST
        GooderData::ApiClient::BadRequestError
      else
        GooderData::ApiClient::Error
      end
    end

    def error_message(response)
      error = response['error'] || {}
      message = error['message'] || ""
      parameters = error['parameters'] || []

      message % parameters
    end

    def basic_options
      {
        headers: {
          "Accept" => "application/json",
          "Cookie" => "$Version=0; GDCAuthSST=#{ @super_secure_token }; $Path=/gdc/account; GDCAuthTT=#{ @temp_token }"
        }
      }
    end

    def send_request(method, path, options = nil)
      self.class.send(method, path, options || basic_options)
    end

    def self.try_hash_chain(hash, *key_chain)
      if hash.is_a?(Hash) || hash.is_a?(HTTParty::Response)
        key = key_chain.delete_at(0)
        value = hash.with_indifferent_access[key]
        return value if key_chain.empty?

        try_hash_chain(value, *key_chain)
      end
    end

    def try_hash_chain(hash, *key_chain)
      self.class.try_hash_chain(hash, *key_chain)
    end

    def success?(response)
      response.code.to_s.start_with?('2')
    end

    def extract_cookie(response, param_name)
      capture_match(response.headers['set-cookie'], /#{ param_name }=([^;]*);/)
    end

    def capture_match(string, regex, mismatch = '')
      match = string.match(regex)
      return mismatch unless match

      c = match.captures
      c.any? ? c.last : mismatch
    end

  end

end

module HTTParty
  class Response
    def that_responds
      yield self
    end
    alias_method :responds, :that_responds

    def processing?
      code == ::GooderData::ApiClient::STILL_PROCESSING || task_status == ::GooderData::ApiClient::STATUS_WAIT
    end

    def task_status
      ::GooderData::ApiClient.try_hash_chain(parsed_response, 'taskState', 'status')
    end
  end
end
