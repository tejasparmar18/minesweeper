# frozen_string_literal: true

class CreateCells < ActiveRecord::Migration[7.0]
  def change
    create_table :cells do |t|
      t.references :board
      t.boolean :mine, default: false
      t.integer :close_mines, default: 0, null: false
      t.integer :row
      t.integer :col
      t.timestamps
    end
  end
end
