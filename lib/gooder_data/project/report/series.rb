module GooderData
  class Project
    class Report
      class Series < Data

        def group(metrics_data, index_data)
          metrics_data.each do |k, values|
            d = {}
            values.each_with_index do |v, i|
              d[index_data.key(i)] = v
            end
            metrics_data[k] = d
          end
        end

      end
    end
  end
end
