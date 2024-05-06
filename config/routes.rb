Rails.application.routes.draw do

  devise_for :admins, skip: [:registrations, :passwords], controllers:{
    sessions: 'admin/sessions'
  }

  devise_for :users, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :posts, only: [:index, :show, :destroy] do
      resources :post_comment, only: [:destroy]
    end
    resources :genres, only: [:index, :create, :edit, :update]
  end

  scope module: :public do
    root 'homes#top'
    get '/about' => 'homes#about'
    get '/tag_searches/search' => 'tag_searches#search'
    get '/searches/search' => 'searches#search'
    resources :users, only: [:index, :edit, :show, :update, :destroy]
    resources :posts do
      resources :post_commets, only: [:create, :destroy]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
