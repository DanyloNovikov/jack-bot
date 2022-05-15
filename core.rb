# frozen_string_literal: true

require 'telegram/bot'
require 'dotenv/load'
Dir['operations/*.rb'].each { |file| require_relative file }

Telegram::Bot::Client.run(ENV['TELEGRAM_TOKEN']) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      Operations::Start.new(bot: bot, message: message).perform
    when '/stop'
      Operations::Stop.new(bot: bot, message: message).perform
    end
  end
end
