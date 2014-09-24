module GooderData
  class Project
    class Report < GooderData::ApiClient
      attr_reader :project_id, :report_id, :data

      WAIT = 'WAIT'

      def self.from_json_hash(hash, options = {})
        link = hash['link']
        match = link.match(/md\/([^\/]+)\/obj\/(\d+)$/)
        GooderData::Project::Report.new(*(match.captures), options)
      end

      def initialize(project_id, report_id, options = {})
        super(options)
        @project_id = project_id || options[:project_id]
        @report_id = report_id.to_i
        @data = nil
      end

      def fetch
        uri = (try_hash_chain(execute, 'execResult', 'dataResult') || '').gsub(/^\/gdc/, '')
        retry_api_to("fetch current dataResult for report #{ report_id }") do
          response = get(uri)
          response.code = STILL_PROCESSING if status(response) == WAIT
          response
        end.responds do |response|
          @data = response.parsed_response
        end
        self
      end

      def series
        Series.parse(@data)
      end

      def x_axis
        XAxis.parse(@data)
      end

      def export(fmt = "pdf")
        get_url_report_export(fmt)
      end

      private

      def status(response)
        try_hash_chain(response.parsed_response, 'taskState', 'status')
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
              result: execute
            }
          })
        end.responds do |response|
          "https://secure.gooddata.com#{(try_hash_chain(response, "uri") || '').to_s}"
        end
      end

    end
  end
end
