module GooderData
  class Project
    class Report
      class XAxis < Data

        def group(metrics_data, index_data)
          index_data.each do |c, index|
            index_data[c] = grab(metrics_data, index)
          end
        end

      end
    end
  end
end
