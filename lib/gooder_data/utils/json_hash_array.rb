module GooderData
  class JsonHashArray

    def self.from_haw_json(api_class, json_hash_array, options = {})
      array = json_hash_array.map do |element|
        JsonHashObject.new(api_class, element, options)
      end
      JsonHashArray.new(api_class, array, options)
    end

    def method_missing(m, *args, &block)
      @array.send(m, *args, &block)
    end

    def where(query = {}, &block)
      if block_given?
        new_array = @array.select(&block)
      else
        key = query.keys[0].to_s
        value = query.values[0]
        new_array = @array.select { |element| element[key] == value }
      end
      JsonHashArray.new(@api_class, new_array, @options)
    end

    def find(query, &block)
      where(query, &block).first
    end

    def all
      @array.dup
    end

    private

    def initialize(api_class, array, options = {})
      @api_class = api_class
      @options = options
      @array = array
    end

  end
end
