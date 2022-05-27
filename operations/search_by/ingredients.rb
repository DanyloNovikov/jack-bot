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
        @bot.api.sendPhoto(
          chat_id: @message.from.id,
          photo: answer['strDrinkThumb']
        )
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: Services::TextHandlerCocktail.new.text_for_message(answer: answer)
        )
      end

      # I know it's terrible, but it's not the code that's terrible, it's the api.
      def handle_message(message:)
        return error(errors: { errors: ['Empty text for search'] }) unless message.methods.include?(:text)

        answer = send_request(message: message)


        return success(answer: JSON.parse(answer.body)['drinks'].first) unless JSON.parse(answer.body)['drinks'].nil?

        error(errors: { errors: ['Found nothing...'] })
      end

      def send_request(message:)
        Faraday.get(
          "https://www.thecocktaildb.com/api/json/v1/#{ENV['COCKTAILS_KEY']}/search.php",
          {
            i: message.text.tr(' ', '_').downcase
          }
        )
      end
    end
  end
end
