# frozen_string_literal: true

require 'logger'

require './lib/database_connector'

class AppConfigurator
  def configure
    setup_database
  end

  def get_logger
    Logger.new($stdout, Logger::DEBUG)
  end

  private

  def setup_database
    DatabaseConnector.establish_connection
  end
end
