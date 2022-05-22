# frozen_string_literal: true

require_relative 'base_controller'
Dir['./operations/*.rb'].each { |file| require_relative "../#{file}" }

module Controllers
  class CallbackController < Controllers::BaseController
    def perform
      case @message.data
      when '/random'
        Operations::Random.new(bot: @bot, message: @message).perform
      else
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: 'This callback exists.'
        )
      end
    end
  end
end
