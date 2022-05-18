# frozen_string_literal: true

module Operations
  class BaseOperation
    attr_reader :body, :message, :server_request_url

    def initialize(bot:, message:)
      @bot = bot
      @message = message
      @server_request_url = set_server_request_url
    end

    def perform
      raise 'must be implement'
    end

    private

    def success
      raise 'must be implement'
    end

    def error
      raise 'must be implement'
    end

    def set_server_request_url
      ENV['BASE_SERVER'] + self.class.to_s.split(':').last.downcase
    end
  end
end
