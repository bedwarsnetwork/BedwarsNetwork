Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "static#home"
  
    devise_for :users
    get '/' => 'static#home', :as => 'home'
    get '/team' => 'static#team', :as => 'team'
    get '/bewerbung' => 'static#application', :as => 'application'
    get '/team/history' => 'static#team_history', :as => 'team_history'
    get '/maps' => 'static#maps', :as => 'maps'
    get '/premium' => 'static#premium', :as => 'premium'
    get '/statistik' => 'static#statistic', :as => 'statistic'
    get '/kontakt' => 'static#contact', :as => 'contact'
    get '/impressum' => 'static#imprint', :as => 'imprint'
    get '/agb' => 'static#tos', :as => 'tos'
    
    resources :chatlogs
    get 'users/:name/statistik' => 'users#statistic', :as => 'user_statistic'
    get 'users/:name' => 'users#show', :as => 'user'
    resources :users
    get 'sitemap.xml' => 'sitemap#index'
end
