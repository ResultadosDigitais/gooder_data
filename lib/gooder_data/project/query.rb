module GooderData
  class Project
    class Query

      def initialize(attribute)
        @query_str = "[#{ attribute.link }]"
      end

      def eq(value)
        append_operation('=', value)
      end

      def not_eq(value)
        append_operation('<>', value)
      end

      def in(*values)
        append_multi_valued_operation('IN', values)
      end

      def not_in(*values)
        append_multi_valued_operation('NOT IN', values)
      end

      private

      def append_operation(operation, value)
        @query_str << " #{ operation } [#{ value.uri }]"
      end

      def append_multi_valued_operation(operation, values)
        uris = values.map{ |v| "[#{ v.uri }]"}.join(', ')
        @query_str << " #{ operation } (#{ uris })"
      end

    end
  end
end
