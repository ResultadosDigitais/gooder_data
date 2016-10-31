module GooderData
  class Project
    class RawReport < GooderData::ApiClient
      attr_reader :project_id, :object_id, :raw_data, :status

      def initialize(project_id, object_id, options = {})
        super(options)

        @project_id = project_id
        @object_id = object_id
        @status = Status::NOT_FETCHED
      end

      def fetch
        return raw_data if fetched?
        retry_api_to("fetch raw report dataResult for object #{ object_id }") do
          get(raw_report_url)
        end.responds do |response|
          @status = Status::FETCHED unless processing?(response)
          @raw_data = response.parsed_response
        end
      end

      private

      def raw_report_url
        result = export_large_report
        try_hash_chain(result, 'uri').gsub(/^\/gdc/, '')
      end

      def export_large_report
        api_to("execute report #{ object_id }") do
          post("/projects/#{ project_id }/execute/raw/", {
            report_req: {
              reportDefinition: "/gdc/md/#{ project_id }/obj/#{ object_id }"
            }
          })
        end
      end

      def no_content?
        fetched? && !raw_data
      end

      def fetched?
        status == GooderData::Project::Status::FETCHED
      end
    end
  end
end
