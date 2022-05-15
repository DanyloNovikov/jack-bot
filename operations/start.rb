# frozen_string_literal: true
module Operations
  class Start < Operations::BaseOperation

    def perform
      return success if send_request.success?

      error(response: send_request)
    end

    private

    def success
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: "Hello, #{@message.from.first_name}"
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
        {
          first_name: @message.from.first_name,
          last_name: @message.from.last_name,
          external_uid: @message.from.id,
          language_code: @message.from.language_code,
          chat_id: @message.chat.id
        }
      )
    end
  end
end
