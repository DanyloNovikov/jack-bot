# frozen_string_literal: true

require_relative 'base_operation'
Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class Start < Operations::BaseOperation
    def perform
      return success if user.save

      error(errors: user.errors)
    end

    private

    def success
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: "Hi! #{@message.from.first_name}"
      )
    end

    def error(errors:)
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: errors.full_messages.join('\n')
      )
    end

    def user
      @user ||= User.create(chat_id: @message.chat.id)
    end
  end
end
