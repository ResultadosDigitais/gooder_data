require 'cgi'

module GooderData

  class Organization < GooderData::ApiClient

    def initialize(options = {})
      super(options)
      connect!
    end

    def create_user(user_email, password, first_name, last_name)
      api_to("create the user '#{ user_email }'") do |options|
        post("/account/domains/#{ options.require(:organization_name) }/users", {
          accountSetting: {
            login: user_email,
            password: password,
            email: user_email,
            verifyPassword: password,
            firstName: first_name,
            lastName: last_name,
            ssoProvider: options.require(:sso_authentication_provider)
          }
        })
      end.that_responds do |response|
        capture_match(response["uri"], /\/profile\/([^\/\Z]*).*$/)
      end
    end

    def get_user(user_email)
      api_to("create the user '#{ user_email }'") do |options|
        get("/account/domains/#{ options.require(:organization_name) }/users?login=#{CGI.escape(user_email)}")
      end.that_responds do |response|
        items = try_hash_chain(response, 'accountSettings', 'items') || ['']
        links = try_hash_chain(items.first, 'accountSetting', 'links', 'self') || ''
        capture_match(links, /\/profile\/([^\/\Z]*).*$/)
      end
    end

  end

end
