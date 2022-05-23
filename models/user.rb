# frozen_string_literal: true

require 'active_record'

class User < ActiveRecord::Base
  validates :external_uid, uniqueness: { message: 'Bot already connected.' }
end
