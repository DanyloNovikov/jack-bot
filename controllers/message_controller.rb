# frozen_string_literal: true

require_relative 'base_controller'
Dir['./operations/*.rb'].each { |file| require_relative "../#{file}" }
Dir['./services/*.rb'].each { |file| require_relative "../#{file}" }

module Controllers
  class MessageController < Controllers::BaseController
    attr_accessor :check_authenticate

    def initialize(message:, bot:)
      super
      @check_authenticate = Services::Authenticate.new(bot: @bot, message: @message)
    end

    def perform
      if @check_authenticate.perform(operation: @message.text.split.first.tr('/', ''))
        commands_request
      else
        @check_authenticate.answer
        update_user
      end
    end

    private

    def commands_request
      case @message.text.split.first.tr('/', '')
      when 'start'
        Operations::Start.new(bot: @bot, message: @message).perform
      when 'stop'
        Operations::Stop.new(bot: @bot, message: @message).perform
      when 'random'
        Operations::Random.new(bot: @bot, message: @message).perform
      when 'search'
        Operations::Search.new(bot: @bot, message: @message).perform
      when 'help'
        Operations::Help.new(bot: @bot, message: @message).perform
      when 'support'
        Operations::Support.new(bot: @bot, message: @message).perform
      else
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: 'Sorry, I dont understand what you mean...'
        )
      end
    end

    def update_user
      User.find_by(external_uid: @message.from.id)&.update(
        first_name: @message.from.first_name,
        username: @message.from.username,
        last_name: @message.from.last_name,
        language_code: @message.from.language_code
      )
    end
  end
end
