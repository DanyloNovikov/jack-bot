# frozen_string_literal: true

require 'active_record'

class User < ActiveRecord::Base
  validates :chat_id, uniqueness: { message: 'Bot already connected.' }
end
