# frozen_string_literal: true

require_relative 'base_operation'
require 'telegram/bot'

Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class IngredientName < Operations::BaseOperation
    def perform
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: 'Enter the name of what you are looking for. example(vodka):'
      )
      @bot.listen do |message|
        return handle_message(message: message)
      end
    end

    private

    def success(answer:)
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: Services::TextHandlerIngredient.new.text_for_message(answer: answer)
      )
    end

    def error(errors:)
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: errors.values.join('\n')
      )
    end

    # I know it's terrible, but it's not the code that's terrible, it's the api.
    def handle_message(message:)
      answer = send_request(message: message)

      if answer.success? && !JSON.parse(answer.body)['ingredients'].nil?
        return success(answer: JSON.parse(answer.body)['ingredients'].first)
      end

      return error(errors: JSON.parse(answer.body)['errors'].first) unless JSON.parse(answer.body)['errors'].nil?

      error(errors: { errors: 'Nothing found...' })
    end

    def send_request(message:)
      Faraday.get(
        'https://the-cocktail-db.p.rapidapi.com/search.php',
        {
          i: message.text
        },
        {
          'X-RapidAPI-Host' => ENV['RAPID_HOST'],
          'X-RapidAPI-Key' => ENV['RAPID_KEY']
        }
      )
    end
  end
end
