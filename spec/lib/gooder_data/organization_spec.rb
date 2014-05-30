require 'spec_helper'

describe GooderData::Organization, :vcr do
  let(:user_email) { nil }
  let(:password) { nil }
  let(:first_name) { nil }
  let(:last_name) { nil }
  let(:options) { successfull_login_options }

  subject(:organization) do
    VCR.use_cassette('GooderData_ApiClient/_api_token/when_there_are_logged_user/should_get_api_token_successfully') do
      GooderData::Organization.new(options)
    end
  end

  describe "#initialize" do
    subject(:initialize) { organization }
    it "should connect to gooddata api" do
      expect_any_instance_of(GooderData::ApiClient).to receive(:connect!).with(no_args)
      initialize
    end
  end

  describe "#create_user" do
    subject(:create_user) { organization.create_user(user_email, password, first_name, last_name) }

    it "organization_name is required" do
      options[:organization_name] = nil
      expect { create_user }.to raise_error GooderData::Configuration::RequiredOptionError
    end

    context "when the organization_name is given" do
      before { options[:organization_name] = 'my_domain' }

      it "should mount the request body with correct parameters" do
        expect(organization).to receive(:post).with(anything, {
            accountSetting: {
              login: user_email,
              password: password,
              email: user_email,
              verifyPassword: password,
              firstName: first_name,
              lastName: last_name,
              ssoProvider: options[:sso_authentication_provider]
            }
          }).and_call_original
        create_user
      end

      it "should request to correct api path" do
        expect(organization).to receive(:post).with("/account/domains/my_domain/users", anything).and_call_original
        create_user
      end

      it "user_email is required" do
        expect { create_user }.to raise_error GooderData::ApiClient::Error
      end

      context "when the the user does not exists" do
        let(:user_email) { 'new.user@example.com' }
        let(:first_name) { 'John' }
        let(:last_name) { 'Smith' }
        let(:password) { 'my new password' }

        it "should create the new user" do
          expect(create_user).not_to be_nil
        end

        it "should return the new user's profile ID" do
          expect(create_user).to eq 'b36f2f698b0ebe125c8568d8d2396f08'
        end
      end

      context "when the the user already exists" do
        let(:user_email) { 'duplicated.user@example.com' }
        let(:first_name) { 'John' }
        let(:last_name) { 'Smith' }
        let(:password) { 'my new password' }

        it "should raise an error indicating the duplicated user" do
          expect { create_user }.to raise_error GooderData::ApiClient::Error, "could not create the user 'duplicated.user@example.com': Account cannot be created. Login name 'duplicated.user@example.com' is already used."
        end
      end
    end
  end

end
