require 'httparty'
require 'json'
require 'gooder_data/configuration'

class GooderData
  include HTTParty

  NOT_FOUND = 404
  UNAUTHORIZED = 401

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= GooderData::Configuration.new
    end

    def configure
      yield(configuration)
      self.base_uri configuration.base_uri
    end
  end

  base_uri self.configuration.base_uri

  def initialize(project_id = self.class.configuration.default_project_id)
    @super_secure_token = ""
    @temp_token = ""
    @project_id = project_id
  end

  def project_id=(project_id)
    @project_id = project_id
  end

  def super_secure_token=(super_secure_token)
    @super_secure_token = super_secure_token
  end

  def api_token=(api_token)
    @temp_token = api_token
  end

  def connect!(user = self.class.configuration.default_user, password = self.class.configuration.default_user_password)
    login!(user, password)
    api_token!
    self
  end

  def login!(user, password)
    self.super_secure_token = login(user, password)
  end

  def login(user, password)
    response = post("/account/login", {
      postUserLogin: {
        login: user,
        password: password,
        remember: 1
      }
    })
    raise "wrong user or password" if response.code == UNAUTHORIZED
    validate(response, "login failed")
    extract_cookie(response, 'GDCAuthSST')
  end

  def api_token!
    self.api_token = api_token
  end

  def api_token
    validate_login
    response = get("/account/token")
    validate(response, "api_token failed")
    extract_cookie(response, 'GDCAuthTT')
  end

  def processes
    validate_api_token
    response = get("/projects/#{@project_id}/dataload/processes")
    validate(response, "could not list processes for project '#{@project_id}' #{ process_id }, graph '#{ executable_graph_path }'")
    response
  end

  def execute_process(process_id, executable_graph_path)
    validate_api_token
    response = post("/projects/#{@project_id}/dataload/processes/#{process_id}/executions", {
      execution: {
        executable: executable_graph_path
      }
    })
    raise try_hash_chain(response, 'error', 'message') if response.code == NOT_FOUND

    validate(response, "could not execute the process #{ process_id }, graph '#{ executable_graph_path }'")
    poll_url = try_hash_chain(response, 'executionTask', 'links', 'poll') || ""
    execution_id = capture_match(poll_url, /\/executions\/([^\/\Z]*).*$/)
  end

  def execute_schedule(schedule_id)
    validate_api_token
    reponse = post("/projects/#{@project_id}/schedules/#{schedule_id}/executions", { execution: {} })
    validate(response, "could not execute schedule '#{ schedule_id }'")
  end

  private

  def validate_api_token
    validate_login
    raise "api token is required at this point: please inform the api_token (temporary token - TT) or call api_token! first" if @temp_token.to_s.empty?
  end

  def validate_login
    raise "login is required at this point: please inform the super_secure_token (SST) or call login! first" if @super_secure_token.to_s.empty?
  end

  def validate(response, error_message)
    raise "#{error_message}: #{response.code}: #{ try_hash_chain(response, 'error', 'message') || response.parsed_response }" unless success?(response)
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

  def basic_options
    {
      headers: {
        "Accept" => "application/json",
        "Cookie" => "$Version=0; GDCAuthSST=#{@super_secure_token}; $Path=/gdc/account; GDCAuthTT=#{@temp_token}"
      }
    }
  end

  def send_request(method, path, options = nil)
    self.class.send(method, path, options || basic_options)
  end

  def try_hash_chain(hash, *key_chain)
    return nil if hash.nil? || key_chain.empty? || !hash.is_a?(Hash) || !hash.include?(key_chain.first)

    key = key_chain.delete_at(0)
    value = hash[key]
    return value if key_chain.empty?

    try_hash_chain(value, *key_chain)
  end

  def success?(response)
    response.code.to_s.start_with?('2')
  end

  def extract_cookie(response, param_name)
    capture_match(response.headers['set-cookie'], /#{param_name}=([^;]*);/)
  end

  def capture_match(string, regex, mismatch = '')
    match = string.match(regex)
    return mismatch unless match

    c = match.captures
    c.any? ? c.last : mismatch
  end

end
