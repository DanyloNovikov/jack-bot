# frozen_string_literal: true

require_relative '../base_operation'
require 'telegram/bot'
Dir['./models/*.rb'].each { |file| require_relative "../../#{file}" }

module Operations
  module SearchBy
    class Ingredients < Operations::BaseOperation
      def perform
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: 'Enter the name of what you are looking for. example(Dry_Vermouth,Gin,Anis):'
        )
        @bot.listen do |message|
          return handle_message(message: message)
        end
      end

      private

      def success(answer:)
        imo = %w[🍷 🍸 🥃 🍹 🧊 🍋 🧉 🍾]
        kb = []
        answer.each do |cocktail|
          kb << Telegram::Bot::Types::InlineKeyboardButton.new(
            text: cocktail['strDrink'] + imo.sample,
            callback_data: "search_by_cocktail_id #{cocktail['idDrink']}"
          )
        end
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: 'That is all i could find',
          reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        )
      end

      # I know it's terrible, but it's not the code that's terrible, it's the api.
      def handle_message(message:)
        return error(errors: { errors: ['Empty text for search'] }) unless message.methods.include?(:text)

        answer = JSON.parse(send_request(message: message).body)['drinks']

        return success(answer: answer) if !answer.nil? && answer != 'None Found'

        error(errors: { errors: ['Found nothing...'] })
      end

      def send_request(message:)
        Faraday.get(
          "https://www.thecocktaildb.com/api/json/#{ENV.fetch('COCKTAILS_VERSION',
                                                              nil)}/#{ENV.fetch('COCKTAILS_KEY', nil)}/filter.php",
          {
            i: message.text.tr(' ', '_').downcase
          }
        )
      end
    end
  end
end
