# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'pg'
require 'active_record'
require 'dotenv/load'

namespace :db do
  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
    ActiveRecord::MigrationContext.new('db/migrate/').migrate
  end

  desc 'Create the database'
  task :create do
    ActiveRecord::Base.establish_connection(ENV['POSTGRESQL'])
    ActiveRecord::Base.connection.create_database(ENV['DATABASE_NAME'])
  end

  desc 'Drop the database'
  task :drop do
    ActiveRecord::Base.establish_connection(ENV['POSTGRESQL'])
    ActiveRecord::Base.connection.drop_database(ENV['DATABASE_NAME'])
  end
end
