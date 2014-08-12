module GooderData
  class Project
    class Report
      class Data

        attr_reader :name, :data

        def self.parse(json)
          return [] unless json

          json = json['xtab_data']
          rows = json['rows']
          columns = json['columns']
          data = json['data']

          datasets = order(rows, columns)

          series = []
          datasets.first['lookups'][0].each do |series_id, series_name|
            series_index = tree_index(datasets.first, series_id)
            d = process(datasets.last, data, series_index)
            series[series_index] = new(series_name, d)
          end
          IndexedHash.new(series, :name)
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
            indexes = order(index, axis_index)
            value = data[indexes.first][indexes.last]
            d[key] = value
          end
          d
        end

      end
    end
  end
end
