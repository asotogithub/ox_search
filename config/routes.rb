Rails.application.routes.draw do
  get 'dictionary/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'dictionary#index'
  get '/search' => 'dictionary#search'
end
