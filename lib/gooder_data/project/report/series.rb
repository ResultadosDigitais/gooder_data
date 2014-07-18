module GooderData
  class Project
    class Report
      class Series

        attr_reader :name, :data

        def self.parse(json)
          json = json['xtab_data']
          rows = json['rows']
          columns = json['columns']
          data = json['data']

          series = []
          rows['lookups'][0].each do |series_id, series_name|
            series_index = tree_index(rows, series_id)
            d = process(columns, data, series_index)
            series[series_index] = new(series_name, d)
          end
          series
        end

        def initialize(name, data)
          @name = name
          @data = data
        end

        def to_s
          name
        end

        private

        def self.tree_index(axis, id)
          axis['tree']['index'][id][0]
        end

        def self.process(axis, data, index)
          d = {}
          axis['lookups'][0].each do |id, key|
            axis_index = tree_index(axis, id)
            value = data[index][axis_index]
            d[key] = value
          end
          d
        end

      end
    end
  end
end
