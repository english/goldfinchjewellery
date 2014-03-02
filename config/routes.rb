Goldfinchjewellery::Application.routes.draw do
  resources :news
  resources :sessions
  root to: redirect("/news")
end
