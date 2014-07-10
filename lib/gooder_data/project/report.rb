module GooderData
  class Project
    class Report < GooderData::ApiClient
      attr_reader :project_id, :report_id

      def self.from_json_hash(hash, options = {})
        link = hash['link']
        match = link.match(/md\/([^\/]+)\/obj\/(\d+)$/)
        GooderData::Project::Report.new(*(match.captures), options)
      end

      def initialize(project_id, report_id, options = {})
        super(options)
        @project_id = project_id || @options[:project_id]
        @report_id = report_id.to_i
        @data = nil
      end

      def fetch
        uri = (execute.try_hash_chain(execute, 'execResult', 'dataResult') || '').gsub(/^\/gdc/, '')
        api_to("fetch current dataResult for report #{ report_id }") do
          get(uri)
        end.responds do |response|
          @data = response
        end
      end

      def series
        validate_fetched_data
        Series.parse(@data)
      end

      def export(fmt = "pdf")
        validate_fetched_data
        get_url_report_export(fmt)
      end

      private

      def validate_fetched_data
        raise "There are no fetched data. Please use fetch first" if @data.nil?
      end

      def execute
        api_to("execute report #{ report_id }") do
          post("/xtab2/executor3", {
            report_req: {
              report: "/gdc/md/#{ project_id }/obj/#{ report_id }"
            }
          })
        end
      end

      def get_url_report_export(fmt)
        api_to("execute report #{ report_id }") do
          post("/exporter/executor", {
            result_req: {
              format: fmt,
              result: execute.to_json
            }
          })
        end.responds do |response|
          url = "https://secure.gooddata.com"
          uri = try_hash_chain(response, "uri") || ''

          "#{url}#{uri.to_s}"
        end
      end

    end
  end
end
