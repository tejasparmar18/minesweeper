# frozen_string_literal: true

class Board < ApplicationRecord
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  # Relationships
  has_many :cells

  # Validations
  validates :name, presence: true
  validates :email, presence: true, format: { with: EMAIL_FORMAT }
  validates :height, numericality: { only_integer: true, greater_than_or_equal_to: 2 }
  validates :width, numericality: { only_integer: true, greater_than_or_equal_to: 2 }
  validates :mines_count, numericality: { only_integer: true, greater_than: 0 }
  validates_with BoardValidator

  before_save :create_cells

  scope :by_recent, -> { order(id: :desc) }

  def create_cells
    (0...height).each do |row|
      (0...width).each do |col|
        cells.new(row:, col:)
      end
    end

    add_bombs
  end

  private

  def add_bombs
    mines_count.times do
      bomb = create_bomb
      cell = find_cell(bomb.row, bomb.col)

      return if cell.blank?

      while cell.mine
        bomb = create_bomb
        cell = find_cell(bomb.row, bomb.col)
      end

      cell.mine = true
      cell.close_mines = 0
      mark_neighbour_cells(bomb.row, bomb.col)
    end
  end

  def create_bomb
    OpenStruct.new(row: rand(height), col: rand(width))
  end

  def find_cell(row, col)
    cells.select { |cell| cell.row == row && cell.col == col }.first
  end

  def mark_neighbour_cells(row, col)
    (-1..1).each do |row_offset|
      (-1..1).each do |col_offset|
        mark_cell(row + row_offset, col + col_offset)
      end
    end
  end

  def mark_cell(row, col)
    return if row.negative? || row >= height || col.negative? || col >= width

    cell = find_cell(row, col)
    cell.close_mines += 1 unless cell.mine
  end
end
