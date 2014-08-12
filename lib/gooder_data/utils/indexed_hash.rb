module GooderData
  class IndexedHash

    def initialize(array, map_key, *args)
      @map_key = map_key;
      @args = args
      update(array)
    end

    def [](key)
      choose(key).send(:[], key)
    end

    def []=(key, value)
      if key.is_a? Fixnum
        method_missing(:[]=, key, value)
      else
        @hash[hash_key(value)] = value
      end
    end

    def method_missing(method, *args, &b)
      array = @hash.values
      r = array.send(method, *args, &b)
      update(array)
      r
    end

    private

    def update(array)
      @hash = {}
      array.each { |e| @hash[hash_key(e)] = e }
    end

    def hash_key(object)
      object.send(@map_key, *@args)
    end

    def choose(key)
      key.is_a?(Fixnum) ? @hash.values : @hash
    end

  end
end
