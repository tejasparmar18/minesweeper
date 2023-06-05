# frozen_string_literal: true

class BoardsController < ApplicationController
  include Pagy::Backend
  before_action :set_board, only: %i[show destroy]

  def index
    @pagy, @boards = pagy(Board.by_recent, items: 10)
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)

    respond_to do |format|
      if @board.save
        format.html { redirect_to board_url(@board), notice: 'Board was successfully created.' }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  def destroy
    @board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url, notice: 'Board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:name, :email, :height, :width, :mines_count)
  end
end
