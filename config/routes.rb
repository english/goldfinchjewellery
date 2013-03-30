Goldfinchjewellery::Application.routes.draw do
  resources :news
  resources :galleries, only: [:index, :show]
  resources :jewelleries
  resources :sessions

  get '/sign_in' => 'sessions#new'
  get '/contact' => 'pages#contact'
  get '/links'   => 'pages#links'
  get '/admin'   => 'pages#admin'

  root to: 'pages#about'
end
