Goldfinchjewellery::Application.routes.draw do
  resources :news_items
  resources :galleries, only: [:index, :show]
  root to: 'pages#about'
  get '/latest-news' => 'pages#latest_news', as: :latest_news
  get '/contact'     => 'pages#contact'
  get '/links'       => 'pages#links'
end
