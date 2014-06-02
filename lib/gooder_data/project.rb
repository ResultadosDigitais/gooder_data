module GooderData

  class Project < GooderData::ApiClient

    def initialize(options = {})
      super(options)
      connect!
    end

    def processes
      api_to("list processes for project '#{ project_id }'") do
        get("/projects/#{ project_id }/dataload/processes")
      end
    end

    def execute_process(process_id, executable_graph_path)
      api_to("execute the process #{ process_id }, graph '#{ executable_graph_path }'") do
        post("/projects/#{ project_id }/dataload/processes/#{ process_id }/executions", {
          execution: {
            executable: executable_graph_path
          }
        })
      end.that_responds do |response|
        poll_url = try_hash_chain(response, 'executionTask', 'links', 'poll') || ""
        execution_id = capture_match(poll_url, /\/executions\/([^\/\Z]*).*$/)
      end
    end

    def execute_schedule(schedule_id)
      api_to("execute schedule '#{ schedule_id }'") do
        post("/projects/#{ project_id }/schedules/#{ schedule_id }/executions", { execution: {} })
      end
    end

    def roles
      api_to("list roles in the project") do
        get("/projects/#{ project_id }/roles")
      end
    end

    def add_user(profile_id, role_id = GooderData::Project::Role::EMBEDDED_DASHBOARD_ONLY)
      api_to("add the user '#{ profile_id }' to project '#{ project_id }'") do |options|
        post("/projects/#{ project_id }/users", {
          user: {
            content: {
              status: "ENABLED",
              userRoles: ["/gdc/projects/#{ project_id }/roles/#{ role_id }"]
            },
            links: {
              self: "/gdc/account/profile/#{ profile_id }"
            }
          }
        })
      end.that_responds do |response|
        error_messages = error_messages_for_profile(response, profile_id)
        raise GooderData::ApiClient::Error, error_messages.join(", ") unless error_messages.empty?
      end
    end

    private

    def error_messages_for_profile(response, profile_id)
      failures = try_hash_chain(response, 'projectUsersUpdateResult', 'failed') || []
      failures.map do |f|
        f['message'] if f['user'] == "/gdc/account/profile/#{ profile_id }"
      end.compact
    end

    def project_id
      @options.require(:project_id)
    end

  end

end
