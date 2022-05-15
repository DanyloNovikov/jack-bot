# frozen_string_literal: true

module Operations
  class BaseOperation
    attr_reader :body, :message

    def initialize(bot:, message:)
      @bot = bot
      @message = message
    end

    def perform
      raise 'must be implement'
    end
  end
end
