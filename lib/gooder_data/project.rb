module GooderData

  class Project < GooderData::ApiClient

    def initialize(options = {})
      super(options)
      connect!
    end

    def processes
      api_to("list processes for project '#{ project_id }'") do
        get(path_for_project("/dataload/processes"))
      end
    end

    def execute_process(process_id, executable_graph_path)
      api_to("execute the process #{ process_id }, graph '#{ executable_graph_path }'") do
        post(path_for_project("/dataload/processes/#{ process_id }/executions"), {
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
        post(path_for_project("/schedules/#{ schedule_id }/executions"), { execution: {} })
      end
    end

    def roles
      api_to("list roles in the project") do
        get(path_for_project("/roles"))
      end
    end

    def add_user(profile_id, role_id = GooderData::Project::Role::EMBEDDED_DASHBOARD_ONLY)
      api_to("add the user '#{ profile_id }' to project '#{ project_id }'") do
        post(path_for_project("/users"), {
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
        error_messages = error_messages_for_profile(response, profile_id, 'projectUsersUpdateResult')
        raise GooderData::ApiClient::Error, error_messages.join(", ") unless error_messages.empty?
      end
    end

    def create_mandatory_user_filter(filter_name, filter_query)
      api_to("create mandatory user filter '#{ filter_name }' => '#{ filter_query }'") do
        post(path_for_model("/obj"), {
          userFilter: {
            content: {
              expression: filter_query
            },
            meta: {
              category: "userFilter",
              title: filter_name
            }
          }
        })
      end.that_responds do |response|
        uri = try_hash_chain(response, 'uri') || ''
        filter_id = capture_match(uri, /\/obj\/([^\/\/S]+)$/)
      end
    end

    def query_attributes
      api_to("list all query attributes of the project") do
        get(path_for_model("/query/attributes"))
      end.responds do |response|
        to_json_hash_array(response, GooderData::Project::QueryAttribute, 'query', 'entries')
      end
    end

    def bind_mandatory_user_filter(filter_id, profile_id)
      api_to("assign mandatory user filter '#{ filter_id }' to profile #{ profile_id }") do
        post(path_for_model('/userfilters'), {
          userFilters: {
            items: [
              {
                user: "/gdc/account/profile/#{ profile_id }",
                userFilters: ["/gdc/md/#{ project_id }/obj/#{ filter_id }"]
              }
            ]
          }
        })
      end.responds do |response|
        error_messages = error_messages_for_profile(response, profile_id, 'userFiltersUpdateResult')
        raise GooderData::ApiClient::Error, error_messages.join(", ") unless error_messages.empty?
      end
    end

    private

    def path_for_project(path)
      "/projects/#{ project_id }#{ path }"
    end

    def path_for_model(path)
      "/md/#{ project_id }#{ path }"
    end

    def error_messages_for_profile(response, profile_id, root_object_name)
      failures = try_hash_chain(response, root_object_name, 'failed') || []
      failures.map do |f|
        f['message'] if f['user'] == "/gdc/account/profile/#{ profile_id }"
      end.compact
    end

    def project_id
      @options.require(:project_id)
    end

  end

end
