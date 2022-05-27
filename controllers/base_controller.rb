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

    private

    def update_user
      User.find_by(external_uid: @message.from.id)&.update(
        external_uid: @message.from&.id || '',
        first_name: @message.from&.first_name || '',
        username: @message.from&.username || '',
        last_name: @message.from&.last_name || '',
        language_code: @message.from&.language_code || ''
      )
    end
  end
end
