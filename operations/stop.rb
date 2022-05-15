# frozen_string_literal: true

module Operations
  class Stop < Operations::BaseOperation

    def perform
      return success if send_request.success?

      error(response: send_request)
    end

    private

    def success
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: "Bye, #{@message.from.first_name}"
      )
    end

    def error(response:)
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: 'Omg! This does not work.'
      )
    end

    def send_request
      Faraday.post(
        @server_request_url,
        { chat_id: @message.chat.id }
      )
    end
  end
end
