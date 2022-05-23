# frozen_string_literal: true

Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class BaseOperation
    attr_reader :body, :message, :current_user

    def initialize(bot:, message:)
      @bot = bot
      @message = message
      @current_user = User.find_by(external_uid: message.from.id)
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
  end
end
