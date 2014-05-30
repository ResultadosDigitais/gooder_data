module GooderData

  class Error < StandardError; end

  class Configuration

    class RequiredOptionError < GooderData::Error; end

    class UnknownOptionError < GooderData::Error; end

  end

  class ApiClient

    class Error < GooderData::Error; end

    class BadRequestError < GooderData::ApiClient::Error; end

  end

end
