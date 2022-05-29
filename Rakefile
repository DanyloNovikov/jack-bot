# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'pg'
require 'active_record'
require 'dotenv/load'

namespace :db do
  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(ENV.fetch('DATABASE_URL', nil))
    ActiveRecord::MigrationContext.new('db/migrate/').migrate
  end

  desc 'Create the database'
  task :create do
    ActiveRecord::Base.establish_connection(ENV.fetch('POSTGRESQL', nil))
    ActiveRecord::Base.connection.create_database(ENV.fetch('DATABASE_NAME', nil))
  end

  desc 'Drop the database'
  task :drop do
    ActiveRecord::Base.establish_connection(ENV.fetch('POSTGRESQL', nil))
    ActiveRecord::Base.connection.drop_database(ENV.fetch('DATABASE_NAME', nil))
  end
end
