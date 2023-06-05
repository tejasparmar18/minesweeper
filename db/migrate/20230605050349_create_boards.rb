# frozen_string_literal: true

class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :email
      t.string :name
      t.integer :height, default: 0, null: false
      t.integer :width, default: 0, null: false
      t.integer :mines_count, default: 0, null: false
      t.timestamps
    end
  end
end
