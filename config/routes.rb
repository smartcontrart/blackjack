Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get 'games/create'
  get 'games/create'
  post 'games/hit'
  post 'games/stand'
  post 'games/double'
  post 'games/split'
  post 'games/end'
end
