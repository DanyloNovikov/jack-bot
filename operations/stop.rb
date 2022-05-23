# frozen_string_literal: true

require_relative 'base_operation'
Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class Stop < Operations::BaseOperation
    def perform
      return success if @current_user.delete

      error(errors: @current_user.errors)
    end

    private

    def success
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: "Bye, #{@message.from.first_name}",
        reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: [
            ['start 🔰']
          ]
        )
      )
    end

    def error(errors = nil)
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: errors&.full_messages&.join('\n') || 'You have not connected this bot'
      )
    end
  end
end
