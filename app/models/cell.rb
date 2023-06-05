# frozen_string_literal: true

class Cell < ApplicationRecord
  # Relationships
  belongs_to :board

  # Validations
  validates :row, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :col, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
