# frozen_string_literal: true

require_relative 'base_operation'
require 'telegram/bot'

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
        text: text_for_message(answer: answer),
        photo: answer['strDrinkThumb'],
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'Give me cocktail',
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
        'https://the-cocktail-db.p.rapidapi.com/random.php',
        {},
        {
          'X-RapidAPI-Host' => ENV['RAPID_HOST'],
          'X-RapidAPI-Key' => ENV['RAPID_KEY']
        }
      )
    end

    def preparation_data(collection:, search:)
      hash = {}
      collection.each do |key, value|
        hash[key] = value if key.include?(search) && !value.nil?
      end
      hash
    end

    def count_ingredients(ingredients:, measures:)
      ingredients = ingredients.values
      measures = measures.values
      hash = {}
      ingredients.each_with_index do |object, index|
        hash[object] = measures[index]
      end
      hash
    end

    def text_for_message(answer:)
      ingredients = count_ingredients(
        ingredients: preparation_data(collection: answer, search: 'strIngredient'),
        measures: preparation_data(collection: answer, search: 'strMeasure')
      )
      text = "Drink: #{answer['strDrink']}\n" \
             "**#{answer['strAlcoholic']}**\n" \
             "Glass: #{answer['strGlass']}\n\n"
      ingredients.each do |ingredient|
        text += "#{ingredient.join(' ')}\n"
      end
      text += "\nInstruction: #{answer['strInstructions']}\n"
    end
  end
end
