module GooderData

  class Configuration

    attr_accessor :base_uri, :good_data_sso_public_key_url, :good_data_sso_recipient
    attr_accessor :sso_authentication_provider, :sso_signer_email, :sso_signer_password, :sso_signature_expiration_in_seconds
    attr_accessor :organization_name, :project_id, :user, :user_password
    attr_accessor :max_retries

    def initialize
      self.base_uri = 'https://secure.gooddata.com/gdc'
      self.good_data_sso_public_key_url = 'https://developer.gooddata.com/downloads/sso/gooddata-sso.pub'
      self.good_data_sso_recipient = 'security@gooddata.com'
      self.sso_signature_expiration_in_seconds = 36 * 3600 # 10 min < expiration < 36 hours; https://developer.gooddata.com/article/gooddata-pgp-single-sign-on
      self.max_reties = 10
    end

    def merge(custom_options)
      options = default_options
      options.validate(custom_options)
      options.merge(custom_options)
    end

    def require(option_name)
      default_options.require(option_name)
    end

    private

    def default_options
      Options.new(
        base_uri: self.base_uri,
        good_data_sso_public_key_url: self.good_data_sso_public_key_url,
        good_data_sso_recipient: self.good_data_sso_recipient,
        sso_authentication_provider: self.sso_authentication_provider,
        sso_signer_email: self.sso_signer_email,
        sso_signer_password: self.sso_signer_password,
        sso_signature_expiration_in_seconds: self.sso_signature_expiration_in_seconds,
        organization_name: self.organization_name,
        project_id: self.project_id,
        user: self.user,
        user_password: self.user_password
        max_retries: self.max_retries
      )
    end

    class Options < Hash

      def initialize(hash)
        super()
        super.merge!(hash)
        self.default_proc = lambda { |_, key| raise_unknown_option_error key }
      end

      def validate(options)
        options.each do |name, _|
          raise_unknown_option_error(name) unless self.include? name
        end
      end

      def require(option_name)
        return self[option_name] unless self[option_name].nil?
        raise RequiredOptionError.new, "#{ option_name } is needed at this point. please inform it by adding :#{ option_name } => \#{value} parameter to method call or using GooderData.configure"
      end

      private

      def _dump(level)
        Marshal.dump({}.merge(self))
      end

      def self._load(args)
        new(Marshal.load(args))
      end

      def raise_unknown_option_error(option_name)
        raise UnknownOptionError.new, "unknown option '#{ option_name }'. See GooderData::Configuration for available options"
      end

    end

  end

end
