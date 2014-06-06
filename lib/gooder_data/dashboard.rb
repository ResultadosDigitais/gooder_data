module GooderData

  class Dashboard

    attr_accessor :project_id

    def initialize(dashboard_id, options = {})
      @dashboard_id = dashboard_id
      @options = GooderData.configuration.merge(options)
    end

    def url(url_options = {})
      project_id = @options.require(:project_id)
      url = "https://secure.gooddata.com/dashboard.html?#project=/gdc/projects/#{ project_id }&dashboard=/gdc/md/#{ project_id }/obj/#{ @dashboard_id }"
      url << "&#{ URI.encode_www_form(url_options) }" unless url_options.nil? || url_options.empty?
      url
    end

  end

end
