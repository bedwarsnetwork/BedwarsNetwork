Rails.application.routes.draw do
  
  root to: "static#home"
  
  devise_for :users
  get '/' => 'static#home', :as => 'home'
  get '/team' => 'static#team', :as => 'team'
  get '/deine-chance' => 'static#youtube', :as => 'deine_chance'
  get '/youtube' => 'static#youtube', :as => 'youtube'
  get '/bewerbung' => 'static#application', :as => 'application'
  get '/team/history' => 'static#team_history', :as => 'team_history'
  get '/maps' => 'static#maps', :as => 'maps'
  get '/premium' => 'static#premium', :as => 'premium'
  get '/statistik' => 'static#statistic', :as => 'statistic'
  get '/kontakt' => 'static#contact', :as => 'contact'
  get '/impressum' => 'static#imprint', :as => 'imprint'
  get '/agb' => 'static#tos', :as => 'tos'
  
  resources :chatlogs
  
  resources :users, path: 'players', except: [:edit, :update], param: :name do
    get 'statistic'
    get 'youtube'
  end
    resources :users, path: 'players/uuid/', only: [:edit]
    resources :users, path: 'players', only: [:update]
  
  get '/players/uuid/:id/' => 'users#show'
  get '/players/uuid/:id/statistic' => 'users#statistic'
  get '/players/uuid/:id/youtube' => 'users#youtube'
  
  get 'sitemap.xml' => 'sitemap#index'
  
end
