# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns paginated boards as @boards' do
      boards = create_list(:board, 10)
      get :index
      expect(assigns(:boards)).to eq(boards.reverse)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #all' do
    it 'assigns all boards' do
      boards = create_list(:board, 50)
      get :all
      expect(assigns(:boards)).to eq(boards)
    end

    it 'renders the all template' do
      get :all
      expect(response).to render_template(:all)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new board as @board' do
      get :new
      expect(assigns(:board)).to be_a_new(Board)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) { { board: attributes_for(:board) } }

      it 'creates a new board' do
        expect do
          post :create, params: valid_params
        end.to change(Board, :count).by(1)
      end

      it 'assigns the newly created board as @board' do
        post :create, params: valid_params
        expect(assigns(:board)).to be_a(Board)
        expect(assigns(:board)).to be_persisted
      end

      it 'redirects to the created board' do
        post :create, params: valid_params
        expect(response).to redirect_to(board_url(assigns(:board)))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { board: attributes_for(:board, name: '') } }

      it 'does not create a new board' do
        expect do
          post :create, params: invalid_params
        end.to_not change(Board, :count)
      end

      it 'assigns a newly created but unsaved board as @board' do
        post :create, params: invalid_params
        expect(assigns(:board)).to be_a_new(Board)
      end

      it 're-renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end

      it 'does not create a new board and adds an error to mines_count attribute' do
        post :create, params: { board: attributes_for(:board, width: 10, height: 10, mines_count: 100) }
        expect(response).to render_template(:new)
        expect(Board.count).to eq(0)
        expect(assigns(:board).errors[:mines_count]).to include('Number of mines must be less than the number of cells(100)')
      end
    end
  end

  describe 'GET #show' do
    let(:board) { create(:board) }

    it 'assigns the requested board as @board' do
      get :show, params: { id: board.id }
      expect(assigns(:board)).to eq(board)
    end

    it 'renders the show template' do
      get :show, params: { id: board.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'DELETE #destroy' do
    let!(:board) { create(:board) }

    it 'destroys the requested board' do
      expect do
        delete :destroy, params: { id: board.id }
      end.to change(Board, :count).by(-1)
    end

    it 'redirects to the boards index' do
      delete :destroy, params: { id: board.id }
      expect(response).to redirect_to(boards_url)
    end
  end
end
