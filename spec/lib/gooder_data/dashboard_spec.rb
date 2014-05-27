require 'spec_helper'

describe GooderData::Dashboard do
  subject(:dashboard) { GooderData::Dashboard.new(dashboard_id, project_id: project_id) }


  describe "#url" do
    let(:dashboard_id) { nil }
    let(:url_options) { nil }
    let(:project_id) { nil }

    subject(:dashboard_url) { dashboard.url(url_options) }

    it "dashboard_id is required" do
      expect { dashboard_url }.to raise_error GooderData::Configuration::RequiredOptionError
    end

    context "when dashboard_id is given" do
      let(:dashboard_id) { 123 }

      it "project_id is needed" do
        expect { dashboard_url }.to raise_error GooderData::Configuration::RequiredOptionError
      end

      context "when the project_id is given" do
        let(:project_id) { 'upymyhqnip7c3dasxxmbz432w32qzdpj' }

        it "sets project_id after gdc/project/ and gdc/md/" do
          expect(dashboard_url).to include "/gdc/projects/#{ project_id }"
        end

        it "sets project_id after gdc/md/" do
          expect(dashboard_url).to include "/gdc/md/#{ project_id }"
        end

        it "generates the url with the project_id" do
          expect(dashboard_url).to eq 'https://secure.gooddata.com/dashboard.html?#project=/gdc/projects/upymyhqnip7c3dasxxmbz432w32qzdpj&dashboard=/gdc/md/upymyhqnip7c3dasxxmbz432w32qzdpj/obj/123'
        end

        context "when url_options are empty" do
          let(:url_options) { {} }

          it "generates the url without the url_options as query parameters" do
            expect(dashboard_url).to eq 'https://secure.gooddata.com/dashboard.html?#project=/gdc/projects/upymyhqnip7c3dasxxmbz432w32qzdpj&dashboard=/gdc/md/upymyhqnip7c3dasxxmbz432w32qzdpj/obj/123'
          end
        end

        context "and url_options are given" do
          let(:url_options) do
            {
              nochrome: 1,
              tab: '8fb5f15fc5bc',
              override: 'ui.link'
            }
          end

          it "appends url_options as query parameters at the end" do
            expect(dashboard_url).to end_with '&nochrome=1&tab=8fb5f15fc5bc&override=ui.link'
          end

          it "generates the url with the query parameters" do
            expect(dashboard_url).to eq 'https://secure.gooddata.com/dashboard.html?#project=/gdc/projects/upymyhqnip7c3dasxxmbz432w32qzdpj&dashboard=/gdc/md/upymyhqnip7c3dasxxmbz432w32qzdpj/obj/123&nochrome=1&tab=8fb5f15fc5bc&override=ui.link'
          end
        end
      end
    end

  end

end
