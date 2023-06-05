# frozen_string_literal: true

Rails.application.routes.draw do
  root 'boards#new'
  resources :boards
end
