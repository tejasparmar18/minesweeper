# frozen_string_literal: true

Rails.application.routes.draw do
  root 'boards#new'
  resources :boards do
    collection do
      get :all
    end
  end
end
