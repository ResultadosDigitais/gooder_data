require 'spec_helper'
require 'gooder_data/session_id'

describe GooderData::SessionId, :vcr do

  let(:user_email) { "user@domain.com" }

  subject(:session_id) { GooderData::SessionId.new(user_email).to_url }

  before do
    @crypto = GPGME::Crypto.new
    allow(GPGME::Crypto).to receive(:new) { @crypto }
    allow(@crypto).to receive(:sign) { |content, options| "Signed" }
    allow(@crypto).to receive(:encrypt) { |content, options| "Encrypted" }
    
    allow(GooderData::SSO).to receive(:import_key!).and_return(true)
  end

  context "given the default configuration" do

    context "and the gooddata-sso public key was not imported" do
      let(:gd_sso_recipient) { GooderData.configuration.good_data_sso_recipient }
      let(:gd_sso_public_key_url) { GooderData.configuration.good_data_sso_public_key_url }

      before do
        allow(GooderData::SSO).to receive(:import_key!).and_return(false)
        allow(GPGME::Key).to receive(:find).with(:public, gd_sso_recipient) { [] } 
      end

      it "should import the gooddata-sso.pub from gd server" do
        expect(GooderData::SSO).to receive(:import_key!).with(gd_sso_public_key_url)
        session_id
      end
    end

    context "and the signer was not given" do
      it "should sign with the default secret" do
        expect(@crypto).to receive(:sign).with(anything, { armor: true })
        session_id
      end

      it "should encrypt the signed content" do
        expect(@crypto).to receive(:encrypt).with("Signed", { recipients: GooderData.configuration.good_data_sso_recipient, armor: true, always_trust: true })
        session_id
      end
    end

    context "and the signer was given" do
      let(:signer) { "custom.user@mail.com" }
      it "should sign with the given signer's secret" do
        expect(@crypto).to receive(:sign).with(anything, { armor: true, signer: signer })
        GooderData::SessionId.new(user_email, sso_signer_email: signer).to_url
      end

      context "and the password was given" do
        let(:password) { "my custom password" }
        it "should sign with the given signer's secret and password" do
          expect(@crypto).to receive(:sign).with(anything, { armor: true, signer: signer, password: password })
          GooderData::SessionId.new(user_email, sso_signer_email: signer, sso_signer_password: password).to_url
        end
      end
    end

  end

end
