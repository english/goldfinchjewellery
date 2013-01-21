Goldfinchjewellery::Application.routes.draw do
  resources :news
  resources :galleries, only: [:index, :show]
  root to: 'pages#about'
  get '/contact' => 'pages#contact'
  get '/links'   => 'pages#links'
end
