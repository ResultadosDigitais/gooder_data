module GooderData
  class Project
    class QueryAttribute < GooderData::ApiClient
      attr_reader :project_id, :attribute_id

      def self.from_json_hash(hash, options = {})
        link = hash['link']
        match = link.match(/md\/([^\/]+)\/obj\/(\d+)$/)
        GooderData::Project::QueryAttribute.new(*(match.captures), options)
      end

      def initialize(project_id, attribute_id, options = {})
        super(options)
        @project_id = project_id || options[:project_id]
        @attribute_id = attribute_id.to_i
        connect!
      end

      def values(label = nil)
        url = elements_link(label).gsub(/^\/gdc/, '')
        api_to("list all available values for query attibute #{ attribute_id }") do
          get(url)
        end.responds do |response|
          to_json_hash_array(response, GooderData::Project::QueryValue, 'attributeElements', 'elements')
        end
      end

      private

      def elements_link(label = nil)
        api_to("retrieves elements link for #{ attribute_id }") do
          get("/md/#{ project_id }/obj/#{ attribute_id }")
        end.responds do |response|
          forms = try_hash_chain(response, 'attribute', 'content', 'displayForms') || [{}]
          form = forms.first
          forms.each do |f|
            identifier = try_hash_chain(f, 'meta', 'identifier') || ''
            if identifier == label
              form = f
              break
            end
          end
          link = try_hash_chain(form, 'links', 'elements') || ''
        end
      end

    end
  end
end
