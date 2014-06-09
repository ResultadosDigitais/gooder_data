module GooderData
  class JsonHashObject

    def initialize(api_class, json_hash, options = {})
      @hash = json_hash
      @api_class = api_class
      @options = options
    end

    def method_missing(m, *args, &block)
      key = m.to_s
      return @hash[key] if @hash.include? key
      return @api_class.from_json_hash(@hash, @options).send(m, *args, &block) if @api_class.method_defined?(m.to_sym)

      begin
        @hash.send(m, *args, &block)
      rescue NoMethodError
        raise NoMethodError, "undefined method `#{ m }' for #{ @api_class }"
      end
    end

  end
end
