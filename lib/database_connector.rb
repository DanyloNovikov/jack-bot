# frozen_string_literal: true

require 'active_record'
require 'logger'

class DatabaseConnector
  class << self
    def establish_connection
      ActiveRecord::Base.logger = Logger.new(active_record_logger_path)
      ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
    end

    private

    def active_record_logger_path
      'debug.log'
    end

    def database_config_path
      'config/database.yml'
    end
  end
end
