Goldfinchjewellery::Application.routes.draw do
  resources :news
  resources :sessions
  resources :jewellery
  root to: redirect("/news")
end
