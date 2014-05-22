class GooderData::Configuration

  attr_accessor :base_uri, :good_data_sso_public_key_url, :good_data_sso_recipient
  attr_accessor :signer_email, :signer_password, :signature_expiration_in_seconds
  attr_accessor :default_project_id, :default_user, :default_user_password

  def initialize
    self.base_uri = 'https://secure.gooddata.com/gdc'
    self.good_data_sso_public_key_url = 'https://developer.gooddata.com/downloads/sso/gooddata-sso.pub'
    self.good_data_sso_recipient = 'security@gooddata.com'
    self.signature_expiration_in_seconds = 36 * 3600 # 10 min < expiration < 36 hours; https://developer.gooddata.com/article/gooddata-pgp-single-sign-on
    self.default_project_id = nil
    self.default_user = nil
    self.default_user_password = nil
  end

end
