# frozen_string_literal: true

require_relative 'base_operation'
require 'telegram/bot'
Dir['./services/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class Random < Operations::BaseOperation
    def perform
      answer = send_request
      return success(answer: JSON.parse(answer.body)['drinks'].first) if answer.success?

      error(errors: JSON.parse(answer.body)['errors'].first)
    end

    private

    def success(answer:)
      @bot.api.sendPhoto(
        chat_id: @message.from.id,
        photo: answer['strDrinkThumb']
      )
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: Services::TextHandlerCocktail.new.text_for_message(answer: answer),
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'Give me random cocktail',
            callback_data: 'random'
          )
        )
      )
    end

    def error(errors:)
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: errors.values.join('\n')
      )
    end

    def send_request
      Faraday.get(
        "https://www.thecocktaildb.com/api/json/v1/#{ENV['COCKTAILS_KEY']}/random.php"
      )
    end
  end
end
