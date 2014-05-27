require 'gpgme'
require 'open-uri'

module GooderData

  class SessionId

    def initialize(user_email, options = {})
      @crypto = GPGME::Crypto.new
      @user_email = user_email
      @options = GooderData.configuration.merge(options)
    end

    def to_url
      import_key!(@options[:good_data_sso_public_key_url]) unless has_key?(@options[:good_data_sso_recipient])

      signed_content = sign(session_id_json)
      encrypted_content = encrypt(signed_content)
      CGI.escape(encrypted_content)
    end

    def has_key?(name)
      GPGME::Key.find(:public, name).any?
    end

    def import_key!(key_file_path_or_url)
      GPGME::Key.import(open(key_file_path_or_url))
    end

    private

    def sign(content)
      @crypto.sign(content, sign_options).to_s
    end

    def encrypt(content)
      @crypto.encrypt(content, recipients: @options[:good_data_sso_recipient], armor: true, always_trust: true).to_s
    end

    def sign_options
      options = {
        armor: true
      }
      options[:signer] = @options[:sso_signer_email] if @options[:sso_signer_email]
      options[:password] = @options[:sso_signer_password] if @options[:sso_signer_password]
      options
    end

    def session_id_json
      {
        email: @user_email,
        validity: Time.now.to_i + @options[:sso_signature_expiration_in_seconds]
      }.to_json
    end

  end

end
