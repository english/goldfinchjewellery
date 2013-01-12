Goldfinchjewellery::Application.routes.draw do
  root to: 'pages#about'
  get '/gallery'     => 'pages#gallery'
  get '/latest-news' => 'pages#latest_news', as: :latest_news
  get '/contact'     => 'pages#contact'
  get '/links'       => 'pages#links'
end
