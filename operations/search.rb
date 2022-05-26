# frozen_string_literal: true

require_relative 'base_operation'
require 'telegram/bot'
Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class Search < Operations::BaseOperation
    def perform
      success
    end

    private

    def success
      kb = [
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: 'Search ingredient by name 🍋',
          callback_data: 'search_by_ingredient_name'
        ),
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: 'Search by name 🍹',
          callback_data: 'search_by_name'
        ),
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: 'Search by ingredients 🧺',
          callback_data: 'search_by_ingredients'
        )
      ]
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: 'Select which attributes to search_by for.',
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      )
    end
  end
end
