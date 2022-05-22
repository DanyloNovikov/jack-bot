# frozen_string_literal: true

Dir['./operations/*.rb'].each { |file| require_relative "../#{file}" }

module Controllers
  class BaseController
    attr_reader :message, :bot

    def initialize(message:, bot:)
      @message = message
      @bot = bot
    end

    def perform
      raise 'must be implement'
    end
  end
end
