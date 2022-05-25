# frozen_string_literal: true

require_relative 'base_controller'
Dir['./operations/*.rb'].each { |file| require_relative "../#{file}" }
Dir['./models/*.rb'].each { |file| require_relative "../#{file}" }

module Controllers
  class MemberController < Controllers::BaseController
    def perform
      User.find_by(external_uid: @message.from.id)&.delete
    end
  end
end
