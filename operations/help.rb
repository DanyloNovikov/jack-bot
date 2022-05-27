# frozen_string_literal: true

require_relative 'base_operation'
require 'telegram/bot'

module Operations
  class Help < Operations::BaseOperation
    def perform
      success
    end

    private

    def success
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: "search - the command is responsible for searching by various attributes such as ingredients, name as well as searching for the description of ingredients simply select search in the context menu or enter search.\n
random - this command returns a random cocktail\n
help - get instruction how use this bot\n
support - to provide financial assistance to our project\n\n
Bot support various ways of interacting both using the interface
and text commands so for example if you enter random or /random
it will be equivalent to clicking on the button"
      )
    end
  end
end
