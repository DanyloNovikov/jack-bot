# frozen_string_literal: true

module Operations
  class Stop < Operations::BaseOperation
    def perform
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: "Bye, #{@message.from.first_name}"
      )
    end
  end
end
