module GooderData
  class Project
    class Report
      class Series

        def self.parse(json)
          [
            new(json['xtab_data'], 0)
          ]
        end

        def initialize(json, series_index)
          @series_index = series_index

          @rows = json['rows']
          @tree_index = @rows['tree']['index']
          @_data = json['data']
        end

        def process
          @data = {}

          @rows['lookups'][@series_index].each do |id, y|
            index = @tree_index[id][@series_index].to_i
            x = @_data[index][@series_index]
            @data[y] = x
          end
          @data
        end

        def data
          @data ||= process
        end

      end
    end
  end
end
