# frozen_string_literal: true

require_relative 'base_controller'
Dir['./operations/*.rb'].each { |file| require_relative "../#{file}" }

module Controllers
  class MessageController < Controllers::BaseController
    def perform
      case @message.text
      when '/start'
        Operations::Start.new(bot: @bot, message: @message).perform
      when '/stop'
        Operations::Stop.new(bot: @bot, message: @message).perform
      when '/random'
        Operations::Random.new(bot: @bot, message: @message).perform
      else
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: 'Sorry, I dont understand what you mean...'
        )
      end
    end
  end
end
