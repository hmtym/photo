Rails.application.routes.draw do
  get 'users/sign_in'

  get 'users/sign_up'

  get 'users/follow_list'

  get 'users/follower_list'

  get 'users/edit'

  get 'users/show'

  get 'posts/new'

  get 'users/top'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/top', to:'users#top', as: :top
  get 'posts/new', to:'posts#new', as: :new_post
  resources :posts do
    member do
      # いいね
      get 'like', to: 'posts#like', as: :like
      post 'comment', to: 'posts#comment', as: :comment
    end
  end  
  delete '/posts/(:id)', to: 'posts#destroy'
  get '/posts/(:id)/like', to: 'posts#like'
  
  get '/profile/edit', to:'users#edit', as: :profile_edit
  post '/profile/edit', to:'users#update'
  get '/profile/(:id)', to:'users#show', as: :profile
  get '/follower_list/(:id)', to:'users#follower_list', as: :follower_list
  get '/follow_list/(:id)', to:'users#follow_list', as: :follow_list
  get '/follow/(:id)', to:'users#follow', as: :follow
  get '/sign_up', to:'users#sign_up', as: :sign_up
  get '/sign_in', to:'users#sign_in', as: :sign_in
  get '/sign_out', to: 'users#sign_out', as: :sign_out
  post 'sign_up', to:'users#sign_up_process'
  post 'sign_in', to:'users#sign_in_process'
end
