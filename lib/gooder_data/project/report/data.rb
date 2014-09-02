module GooderData
  class Project
    class Report
      class Data

        attr_reader :data, :raw_data

        def self.parse(json)
          return [] unless json && json['xtab_data']

          json = json['xtab_data']
          new(json)
        end

        def initialize(raw_data)
          @raw_data = raw_data
          @data = parse
        end

        def metrics_axis
          rows
        end

        def index_axis
          columns
        end

        def rows
          raw_data['rows']
        end

        def columns
          raw_data['columns']
        end

        def parse
          metrics_data = process(rows['tree'], rows['lookups'])
          index_data = process(columns['tree'], columns['lookups'], false)

          index_data.each do |c, index|
            index = index.values.first while index.is_a?(Hash)
            index_data[c] = index
          end

          group(metrics_data, index_data)
        end

        def group(metrics_data, index_data)
          index_data.each do |c, index|
            index_data[c] = grab(metrics_data, index)
          end
        end

        def grab(hash, index)
          new_hash = {}
          hash.each do |k, v|
            if v.is_a? Array
              new_hash[k] = v[index]
            else
              new_hash[k] = grab(hash[k], index)
            end
          end
          new_hash
        end

        def metrics_data?(tree)
          children = tree['children']
          return tree['type'] == 'metric' if children.empty?
          metrics_data?(children.first)
        end

        def process(tree, lookups, fetch_data = true, level = -1)
          children = tree['children']
          id = tree['id'] && id = lookups[level][id]
          index = tree['first']
          value = fetch_data ? raw_data['data'][index] : index
          return { id => value } if children.empty?

          d = children.reduce({}) do |men, child|
            men.merge(process(child, lookups, fetch_data, level + 1))
          end
          id ? { id => d } : d
        end

        def method_missing(m, *args, &block)
          data.send(m, *args, &block)
        end

      end
    end
  end
end
