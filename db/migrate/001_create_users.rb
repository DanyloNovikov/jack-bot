# frozen_string_literal: true

require 'active_record'

class CreateUsers < ActiveRecord::Migration[7.0]
  def up
    create_table :users, force: true do |t|
      t.string :first_name,     null: false, default: ''
      t.string :last_name,      null: false, default: ''
      t.string :external_uid,   null: false, default: ''
      t.string :language_code,  null: false, default: ''
      t.string :chat_id,        null: false, default: ''

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
