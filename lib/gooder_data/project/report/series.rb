module GooderData
  class Project
    class Report
      class Series < Data

        def self.order(first, last)
          [first, last]
        end

      end
    end
  end
end
