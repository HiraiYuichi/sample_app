Rails.application.routes.draw do 
 root 'static_pages#home'
 get  '/help'=>'static_pages#help'
 get  '/about'=>'static_pages#about'
 get  '/contact'=>'static_pages#contact'
 
 get  '/signup'=>'users#new'
post '/signup'=> 'users#create'
 
 #sessionsリソースの名前付きルートを追加
 get    '/login'=>'sessions#new'
 post   '/login'=> 'sessions#create'
 delete '/logout'=>'sessions#destroy'
 resources :users

end
