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
          text: 'Search by name',
          callback_data: 'name'
        ),
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: 'Search by category',
          callback_data: 'category'
        ),
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: 'Search by glass',
          callback_data: 'glass'
        ),
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: 'Search by ingredients',
          callback_data: 'ingredients'
        )
      ]
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: 'Select which attributes to search for.',
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      )
    end
  end
end
