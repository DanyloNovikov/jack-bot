# frozen_string_literal: true

require 'active_record'

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name,     null: false, default: ''
      t.string :last_name,      null: false, default: ''
      t.string :external_uid,   null: false, default: ''
      t.string :language_code,  null: false, default: ''
      t.string :username,       null: false, default: ''

      t.timestamps
    end
  end
end
