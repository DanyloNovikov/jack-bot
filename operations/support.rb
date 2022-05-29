# frozen_string_literal: true

require_relative 'base_operation'
require 'telegram/bot'
Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class Support < Operations::BaseOperation
    def perform
      success
    end

    private

    def success
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: "We do not want to insert advertising as it will cause you discomfort, but we need at least some funds to
maintain this service, and so this serves us as a motivation for further development of the service, we rely only on
your support 🥺\n\n
Check our Patreon. We will post more bots!
Patreon: https://www.patreon.com/join/jack_bot/checkout?ru=undefined\n
Bitcoin: 1CAXJxaEzPWvPN2vwVr6SZaVVPvZs2SAo6\n
Ethereum: 0x8889D03339B16Ba3c2111fEa8C0c51a387c446Fc"
      )
    end
  end
end
