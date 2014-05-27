require 'spec_helper'

describe GooderData::SSO do
  let(:user_email) { 'user@example.org' }
  let(:organization_name) { 'organization_name' }
  let(:session_id) { double('session_id') }
  let(:generated_session_id) { 'url_encoded_session_id' }

  before(:each) do
    allow(session_id).to receive(:to_url) { generated_session_id }
    allow(GooderData::SessionId).to receive(:new).with(user_email, anything) { session_id }
  end

  subject(:sso) { GooderData::SSO.new(user_email, options) }

  describe "#url" do
    let(:target_url) { 'https://secure.gooddata.com/dashboard.html?#project=/gdc/projects/upymyhqnip7c3dasxxmbz432w32qzdpj&dashboard=/gdc/md/upymyhqnip7c3dasxxmbz432w32qzdpj/obj/123' }
    let(:encoded_target_url_without_host) { '%2Fdashboard.html%3F%23project%3D%2Fgdc%2Fprojects%2Fupymyhqnip7c3dasxxmbz432w32qzdpj%26dashboard%3D%2Fgdc%2Fmd%2Fupymyhqnip7c3dasxxmbz432w32qzdpj%2Fobj%2F123' }

    subject(:sso_url) { sso.url(target_url) }

    context "when organization_name is configured" do
      let(:options) { { organization_name: organization_name } }

      it "should generate new SessionId" do
        expect(GooderData::SessionId).to receive(:new).with(user_email, anything) { session_id }
        sso_url
      end

      it "should generate url with the generated session_id, url encoded organization name and url encoded target url without the host" do
        expect(sso_url).to eq "https://secure.gooddata.com/gdc/account/customerlogin?sessionId=#{ generated_session_id }&serverURL=#{ organization_name }&targetURL=#{ encoded_target_url_without_host }"
      end
    end
  end

end
