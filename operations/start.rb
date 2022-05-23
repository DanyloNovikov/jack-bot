# frozen_string_literal: true

require_relative 'base_operation'
require 'telegram/bot'
Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class Start < Operations::BaseOperation
    def perform
      return success if (user = User.create(external_uid: @message.from.id))

      error(errors: user.errors)
    end

    private

    def success
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: "Hi! #{@message.from.first_name}",
        reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: [
            ['search 🔎', 'random 🎲'],
            ['help 🆘', 'support 💸'],
            ['stop ⏹']
          ]
        )
      )
    end

    def error(errors:)
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: errors.full_messages.join('\n')
      )
    end
  end
end
