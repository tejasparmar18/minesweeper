# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should allow_value('test@example.com', 'another@example.com').for(:email) }
    it { should_not allow_value('invalid_email', 'example.com').for(:email) }
    it { should validate_numericality_of(:height).only_integer.is_greater_than_or_equal_to(2) }
    it { should validate_numericality_of(:width).only_integer.is_greater_than_or_equal_to(2) }
    it { should validate_numericality_of(:mines_count).only_integer.is_greater_than(0) }
  end

  describe 'associations' do
    it { should have_many(:cells) }
  end

  describe 'callbacks' do
    describe '#after_validation :create_cells' do
      let(:board) { create(:board, height: 4, width: 4) }

      it 'creates cells after validation' do
        expect(board.cells.count).to eq(16)
      end

      it 'sets unique mines on cells' do
        mines_count = board.cells.where(mine: true).count
        expect(mines_count).to eq(board.mines_count)
      end

      it 'marks neighboring cells correctly' do
        non_mine_cells = board.cells.where(mine: false)
        non_mine_cells.each do |cell|
          expect(cell.close_mines).to eq(board.cells.where(mine: true, row: cell.row - 1..cell.row + 1,
                                                           col: cell.col - 1..cell.col + 1).count)
        end
      end
    end
  end

  describe 'scopes' do
    describe '.by_recent' do
      let!(:board1) { create(:board, created_at: 2.days.ago) }
      let!(:board2) { create(:board, created_at: 1.day.ago) }
      let!(:board3) { create(:board) }

      it 'orders boards by descending ID' do
        expect(Board.by_recent).to eq([board3, board2, board1])
      end
    end
  end
end
