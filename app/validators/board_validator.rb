class BoardValidator < ActiveModel::Validator
  def validate(record)
    cells_count = record.width * record.height

    if record.mines_count >= cells_count
      record.errors.add :mines_count, "Number of mines must be less than the number of cells(#{cells_count})"
    end
  end
end