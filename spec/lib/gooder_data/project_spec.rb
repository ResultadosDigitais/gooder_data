require 'spec_helper'

describe GooderData::Project, :vcr do
  subject(:project) { GooderData::Project.new(options) }

  let(:project_id) { 'ex4mplepr0ject1daxxmbz432w32qzdj' }

  let(:graph) { 'my_project/graph/my_awesome_graph.grf' }

  let(:options) { test_options(project_id: project_id) }

  describe "#initialize" do
    it "connects with given credentials" do
      expect_any_instance_of(GooderData::ApiClient).to receive(:connect!).with(no_args)
      subject
    end
  end

  describe "#execute_process" do
    subject(:execute_process) { project.execute_process(process_id, graph) }

    let(:process_id) { 'ex4mple4-e1b0-4524-b20b-pr0ce551decb' }

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

  describe "#add_user" do
    subject(:add_user) { project.add_user(profile_id, role_id) }

    let(:profile_id) { 'm0ckedpr0f1le0000000000000000002' }

    let(:role_id) { GooderData::Project::Role::EMBEDDED_DASHBOARD_ONLY }

    context "when the given user does not exists" do
      let(:profile_id) { '123123123' }

      it "raises error from GD API telling that the user was not found" do
        expect { add_user }.to raise_error GooderData::ApiClient::Error, "Cannot add user to project. User doesn't exist"
      end
    end

    context "when the given role_id does not exists" do
      let(:role_id) { 999 }

      it "raises error from GD API telling that the role was not found" do
        expect { add_user }.to raise_error GooderData::ApiClient::Error, "User cannot be added into specified roles"
      end
    end

    context "when the user does not have authorization for adding user" do
      it "raises error from GD API telling that the authenticated user does not have authorization" do
        expect { add_user }.to raise_error GooderData::ApiClient::Error, "could not add the user '#{ profile_id }' to project '#{ project_id }': Current user has missing permission canAssignUserWithRole in project /gdc/projects/#{ project_id }"
      end
    end

    context "when the authenticated user has authorization for adding new users" do
      context "when the given user is a new user" do
        it "adds the user to the project" do
          expect{ add_user }.not_to raise_error
        end
      end

      context "when the given user already exists" do
        it "updates the user's role with the given one" do
          expect{ add_user }.not_to raise_error
        end
      end
    end
  end

  describe "#roles" do
    subject(:roles) { project.roles }

    it "should list all the roles" do
      expect(roles).not_to be_nil
    end
  end

end
