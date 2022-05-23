# frozen_string_literal: true

require_relative 'base_operation'
require 'telegram/bot'
Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Operations
  class Glass < Operations::BaseOperation
    def perform; end

    private

    def success; end

    def error(errors:); end
  end
end
