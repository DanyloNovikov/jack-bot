# frozen_string_literal: true

require 'telegram/bot'
require 'dotenv/load'
require 'active_record'
require 'yaml'

Dir['operations/*.rb'].each { |file| require_relative file }
configuration = YAML.safe_load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection(configuration)

Telegram::Bot::Client.run(ENV['TELEGRAM_TOKEN']) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      Operations::Start.new(bot: bot, message: message).perform
    when '/stop'
      Operations::Stop.new(bot: bot, message: message).perform
    when '/random'
      Operations::Random.new(bot: bot, message: message).perform
    else
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Sorry, I dont understand what you mean...'
      )
    end
  end
end
