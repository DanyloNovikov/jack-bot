# frozen_string_literal: true

require_relative 'base_controller'
Dir['./operations/*.rb'].each { |file| require_relative "../#{file}" }
Dir['./operations/search_by/*.rb'].each { |file| require_relative "../#{file}" }
Dir['./services/*.rb'].each { |file| require_relative "../#{file}" }

module Controllers
  class CallbackController < Controllers::BaseController
    attr_accessor :check_authenticate

    def initialize(message:, bot:)
      super
      @check_authenticate = Services::Authenticate.new(bot: @bot, message: @message)
    end

    def perform
      if @check_authenticate.perform(operation: @message.data.split.first)
        update_user
        commands_request
      else
        @check_authenticate.answer
        update_user
      end
    end

    private

    def commands_request
      case @message.data
      when 'random'
        Operations::Random.new(bot: @bot, message: @message).perform
      when 'search_by_name'
        Operations::SearchBy::Name.new(bot: @bot, message: @message).perform
      when 'search_by_ingredient_name'
        Operations::SearchBy::IngredientName.new(bot: @bot, message: @message).perform
      when 'search_by_ingredients'
        Operations::SearchBy::Ingredients.new(bot: @bot, message: @message).perform
      else
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: 'This callback exists.'
        )
      end
    end
  end
end
