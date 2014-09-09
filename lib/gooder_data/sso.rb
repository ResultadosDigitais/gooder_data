require 'gpgme'
require 'open-uri'

module GooderData

  class SSO

    def initialize(user_email, options = {})
      @user_email = user_email
      @options = GooderData.configuration.merge(options)
    end

    def url(target_url)
      session_id = GooderData::SessionId.new(@user_email, @options).to_url
      server_url = CGI.escape(@options.require(:sso_authentication_provider))
      target_url = CGI.escape(target_url.gsub(/^(.*:\/\/)?([^\/\.]*\.[^\/\.]*){1,}/, ''))
      "https://secure.gooddata.com/gdc/account/customerlogin?sessionId=#{ session_id }&serverURL=#{ server_url }&targetURL=#{ target_url }"
    end

    def self.key?(name)
      GPGME::Key.find(:public, name).any?
    end

    def self.import_key!(key_file_path_or_url)
      GPGME::Key.import(open(key_file_path_or_url))
    end

  end

end
