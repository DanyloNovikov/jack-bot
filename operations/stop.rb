# frozen_string_literal: true

require_relative 'base_operation'
Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class Stop < Operations::BaseOperation
    def perform
      return success if user.delete

      error(errors: user.errors)
    end

    private

    def success
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: "Bye, #{@message.from.first_name}"
      )
    end

    def error(errors:)
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: errors.full_messages.join('\n')
      )
    end

    def user
      @user ||= User.find_by(external_uid: @message.from.id)
    end
  end
end
