# frozen_string_literal: true

Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Services
  class Authenticate
    attr_reader :admissible, :bot, :message

    def initialize(bot:, message:)
      @admissible = %w[start]
      @bot = bot
      @message = message
    end

    def perform(operation:)
      return true unless User.find_by(external_uid: @message.from.id).nil?

      true if @admissible.include?(operation)
    end

    def answer
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: "#{@message.from.first_name}, you are not authorized please press start."
      )
    end
  end
end
