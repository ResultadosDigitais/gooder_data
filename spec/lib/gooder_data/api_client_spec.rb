require 'spec_helper'

describe GooderData::ApiClient, :vcr do

  let(:user) { 'user@example.org' }
  let(:password) { 'my_password' }
  let(:project_id) { 'ex4mplepr0ject1daxxmbz432w32qzdj' }
  let(:process_id) { 'ex4mple4-e1b0-4524-b20b-pr0ce551decb' }
  let(:graph) { 'my_project/graph/my_awesome_graph.grf' }

  let(:gd) { GooderData::ApiClient.new(project_id: project_id) }

  describe "#login" do
    subject(:login) { gd.login(user, password) }
    let(:sst) { login }

    context "when the user and the password are correct" do
      it "should login successfully" do
        login.to_s.should_not be_empty
      end

      it "should return the super secure token" do
        sst.should eq 'M0ckEdSST0000001'
      end
    end

    context "when the user and the password are incorrect" do
      let(:user) { 'wrong_user@mail.com' }
      let(:password) { 'wrongpassword' }
      it "should raise error" do
        expect { login }.to raise_error "wrong user or password for user #{ user }"
      end
    end
  end

  shared_examples "login is required" do
    context "when there are no logged user" do
      it "should raise error instructing to login first" do
        expect { subject }.to raise_error "login is required at this point: please inform the super_secure_token (SST) or call login! first"
      end
    end
  end

  describe "#api_token" do
    subject(:api_token) { gd.api_token }

    it_behaves_like "login is required"

    context "when there are logged user" do
      before { gd.login!(user, password) }

      it "should get api token successfully" do
        api_token.to_s.should_not be_empty
      end

      it "should return the temporary token as api token" do
        api_token.should eq 'pd4bZoguqAWDpNPliomGRVvGA_CoCSOki6IKfOFDiJhJuvwyIs3dlyi8oiCdpDUa1dPIHXm18DPfvaFQfSqst57WoeepmOkMdepsJ-Y9jyZAPk0nNI8A8QqRMS8LFnH4O_aaOqdZO_RD8t_y3hyTm2AWz2g75FQlx8FbFwsaR7t7InYiOjE0MDAyNzAzMzEsInUiOiI2NjYzODAiLCJsIjoiMCIsImsiOiI0MTZlODFlMS1iZTFhLTRkMTQtYWYwNS01OWIyOTcwODdlMzcifQ'
      end
    end
  end

  describe "#execute_process" do
    subject(:execute_process) { gd.execute_process(process_id, graph) }

    it_behaves_like "login is required"

    context "when there are logged user" do
      before { gd.login!(user, password) }

      context "and the api token were not given" do
        it "should raise error instructing to request api token first" do
          expect { subject }.to raise_error "api token is required at this point: please inform the api_token (temporary token - TT) or call api_token! first"
        end
      end

      context "and the api token were set" do
        before { gd.api_token! }

        context "and the given process_id is the id of an inexistant process" do
          let(:process_id) { '123123' }

          it "should raise error warning that process is inexistant" do
            expect { execute_process }.to raise_error "could not execute the process #{ process_id }, graph '#{ graph }': Process #{ process_id } not found."
          end
        end

        context "and the given graph_path references an inexistant graph" do
          let(:graph) { 'my_project/graph/INEXISTANT.grf' }

          it "should raise error warning that process is inexistant" do
            expect { execute_process }.to raise_error "could not execute the process #{ process_id }, graph '#{ graph }': Graph #{ graph } not found in process #{ process_id }"
          end
        end

        context "and the given process_id and graph path exists" do

          it "should be able to execute an existing process" do
            expect { execute_process }.to_not raise_error
          end

          it "should return the execution id" do
            expect(execute_process).to eq '5379fb1de4b0b35947aa1510'
          end
        end
      end
    end
  end

end
