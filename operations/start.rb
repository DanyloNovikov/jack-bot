# frozen_string_literal: true

module Operations
  class Start < Operations::BaseOperation
    def perform
      return success if send_request.success

      error(response: send_request)
    end

    def success
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: "Hello, #{@message.from.first_name}"
      )
    end

    def error(response:)
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: ''
      )
    end

    private

    def send_request
      Faraday.post(
        @server_request_url,
        {
          first_name: @message.from.first_name,
          last_name: @message.from.last_name,
          chat_id: @message.chat.id
        }
      )
    end
  end
end
