require 'gpgme'
require 'open-uri'

module GooderData

  class SessionId

    def initialize(session_user_email, signer_email = configuration.signer_email, signer_password = configuration.signer_password, signature_expiration_in_seconds = configuration.signature_expiration_in_seconds)
      @crypto = GPGME::Crypto.new
      @session_user_email = session_user_email
      @signer_email = signer_email
      @signer_password = signer_password
      @signature_expiration_in_seconds = signature_expiration_in_seconds
    end

    def to_url
      import_key!(configuration.good_data_sso_public_key_url) unless has_key?(configuration.good_data_sso_recipient)

      signed_content = sign(session_id_json.to_s)
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
      @crypto.encrypt(content, recipients: configuration.good_data_sso_recipient, armor: true, always_trust: true).to_s
    end

    def sign_options
      options = {
        armor: true
      }
      options[:signer] = @signer_email if @signer_email
      options[:password] = @signer_password if @signer_password
      options
    end

    def session_id_json
      {
        email: @session_user_email,
        validity: Time.now.to_i + @signature_expiration_in_seconds
      }
    end

    def configuration
      GooderData.configuration
    end

  end

end
