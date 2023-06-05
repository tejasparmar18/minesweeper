require 'rails_helper'

RSpec.describe BoardValidator do
  let(:validator) { described_class.new }
  let(:board) { build(:board, width: 10, height: 10) }

  describe '#validate' do
    context 'when the number of mines is greater than or equal to the number of cells' do
      it 'adds an error to mines_count attribute' do
        board.mines_count = board.width * board.height
        validator.validate(board)

        expect(board.errors[:mines_count]).to include('Number of mines must be less than the number of cells(100)')
      end
    end

    context 'when number of mines is less than cells count' do
      it 'does not add an error to mines_count attribute' do
        board.mines_count = board.width * board.height - 1
        validator.validate(board)
        expect(board.errors[:mines_count]).to be_empty
      end
    end
  end
end
