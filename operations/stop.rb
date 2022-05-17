# frozen_string_literal: true

module Operations
  class Stop < Operations::BaseOperation

    def perform
      answer = send_request
      return success if answer.success?

      error(errors: JSON.parse(answer.body)['errors'].first)
    end

    private

    def success
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: "Bye, #{@message.from.first_name}"
      )
    end

    def error(errors:)
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: errors.values.join('\n')
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
