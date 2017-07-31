Rails.application.routes.draw do

  root to: "static#home"

  get '/bewerbung' => 'static#application', :as => 'application'
  
  localized do
    get "/404" => "errors#not_found"
    get "/422" => "errors#change_rejected"
    get "/500" => "errors#internal_server_error"
  
    concern :paginatable do
      get '(page/:page)', :action => :index, :on => :collection
    end
  
    concern :searchable do
      get 'search/:search', :action => :search, :on => :collection, as: 'search_result'
      post 'search/', :action => :search, :on => :collection, :as => 'search'
    end
  
    concern :search_paginatable do
      get 'search/:search/(page/:page)', :action => :search, :on => :collection
    end
  
    devise_for :users, path: 'account'
    get '/' => 'static#home', :as => 'home'
    get '/team' => 'static#team', :as => 'team'
    get '/your-chance' => 'static#youtube', :as => 'deine_chance'
    get '/youtube' => 'static#youtube', :as => 'youtube'
    get '/team/history' => 'static#team_history', :as => 'team_history'
    get '/maps' => 'static#maps', :as => 'maps'
    get '/premium' => 'static#premium', :as => 'premium'
    get '/statistics' => 'static#statistic_bedwars', :as => 'statistic'
    get '/statistics/bedwars' => 'static#statistic_bedwars', :as => 'statistic_bedwars'
    get '/statistics/location' => 'static#statistic_country', :as => 'statistic_country'
    get '/contact' => 'static#contact', :as => 'contact'
    get '/faq' => 'static#faq', :as => 'faq'
    get '/imprint' => 'static#imprint', :as => 'imprint'
    get '/tos' => 'static#tos', :as => 'tos'
  
    resources :chatlogs, only: [:show]
  
    resources :users, path: 'players', except: [:edit, :update], param: :name, :concerns => [:searchable] do
      get 'statistic'
      get 'youtube'
    end
  
    resources :users, path: 'players/uuid/', only: [:edit]
    resources :users, path: 'players', only: [:update]
  
    get '/players/uuid/:id/' => 'users#show'
    get '/players/uuid/:id/statistic' => 'users#statistic'
    get '/players/uuid/:id/youtube' => 'users#youtube'
  
    get 'sitemap.xml' => 'sitemap#index'
  
    namespace :dashboard, layout: 'dashboard' do
      get '/' => 'users#online', :as => 'dashboard'
      resources :serverstatistics, :concerns => [:searchable, :search_paginatable, :paginatable]
      resources :chatlogs, :concerns => [:searchable, :search_paginatable, :paginatable]
      resources :users, path: 'players', :concerns => [:searchable, :search_paginatable, :paginatable] do
        get 'online', :on => :collection
        get 'chatlogs'
      end
    end
  end

end
