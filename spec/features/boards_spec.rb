# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boards', type: :feature do
  let(:board) { create(:board) }

  describe 'Index View' do
    before { visit boards_path }

    it 'displays all boards' do
      expect(page).to have_selector('table tbody tr', count: Board.count)
    end

    it 'displays the correct table headers' do
      expect(page).to have_selector('table thead th', text: 'Name')
      expect(page).to have_selector('table thead th', text: 'Email')
      expect(page).to have_selector('table thead th', text: 'Created At')
    end

    it 'displays pagination links' do
      expect(page).to have_selector('.pagination')
    end
  end

  describe 'New View' do
    before { visit new_board_path }

    it 'displays the form fields' do
      expect(page).to have_field('board_name')
      expect(page).to have_field('board_email')
      expect(page).to have_field('board_width')
      expect(page).to have_field('board_height')
      expect(page).to have_field('board_mines_count')
    end

    it 'creates a new board with valid data' do
      fill_in 'board_name', with: 'Test Board'
      fill_in 'board_email', with: 'test@example.com'
      fill_in 'board_width', with: 10
      fill_in 'board_height', with: 10
      fill_in 'board_mines_count', with: 5
      click_button 'Generate Board'
      expect(current_path).to eq(board_path(Board.last))
    end

    it 'displays error messages with invalid data' do
      click_button 'Generate Board'
      expect(page).to have_selector('.invalid-feedback')
    end
  end

  describe 'Show View' do
    before { visit board_path(board) }

    it 'displays the board name and email' do
      expect(page).to have_content(board.name)
      expect(page).to have_content(board.email)
    end

    it 'displays the cells of the board' do
      expect(page).to have_selector('.row .d-flex.flex-row', count: board.height)
    end
  end
end
