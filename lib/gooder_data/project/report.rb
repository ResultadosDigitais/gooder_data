module GooderData
  class Project
    class Report < GooderData::ApiClient
      attr_reader :project_id, :report_id, :data, :status

      ACCEPTED = 202

      def self.from_json_hash(hash, options = {})
        link = hash['link']
        match = link.match(/md\/([^\/]+)\/obj\/(\d+)$/)
        GooderData::Project::Report.new(*(match.captures), options)
      end

      def initialize(project_id, report_id, options = {})
        super(options)
        @project_id = project_id || options[:project_id]
        @report_id = report_id.to_i
        reset
      end

      def fetch
        return self if fetched?

        retry_api_to("fetch current dataResult for report #{ report_id }") do
          get(data_fetch_url)
        end.responds do |response|
          @status = Status::FETCHED unless processing?(response)
          @data = response.parsed_response
        end
        self
      end

      def fetch!
        fetch
        fail "Report data could not be fetched" unless fetched?
      end

      def series
        Series.parse(data)
      end

      def x_axis
        XAxis.parse(data)
      end

      def export(fmt = "pdf")
        url = get_url_report_export(fmt)
        download_file(url)
      end

      def no_content?
        fetched? && !data
      end

      def fetched?
        status == Status::FETCHED
      end

      def reset
        @data = nil
        @data_fetch_url = nil
        @status = Status::NOT_FETCHED
      end

      private

      def data_fetch_url
        @data_fetch_url ||= (try_hash_chain(execute, 'execResult', 'dataResult') || '').gsub(/^\/gdc/, '')
      end

      def execute
        api_to("execute report #{ report_id }") do
          post("/projects/#{ project_id }/execute", {
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

      def download_file(url)
        response = get(url)
        while response.code == ACCEPTED do
          response = get(url)
        end
        response
      end

    end
  end
end
