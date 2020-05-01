require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  telegram_webhook TgAdapterController
  post 'vkadapter', to: 'vk_adapter#events'
  devise_for :users, skip: :omniauth_callbacks

  devise_for :users, skip: [:session, :password, :registration, :confirmation],
    controllers: { omniauth_callbacks: 'authentications' }

  devise_scope :user do
    get 'authentications/new', to: 'authentications#new'
    post 'authentications/link', to: 'authentications#link'
  end

  namespace :admin do
    resources :helps, only: :index
    resource  :settings, only: [:edit, :update]

    resources :users, except: :show do
      collection { post :batch_action }
    end

    resources :chat_trees do
      collection { get :show_main }
      collection { post :batch_action }
    end

    resources :chat_messages, only: [:new, :create, :edit, :update, :destroy]
    resources :chat_answers, only: [:new, :create, :edit, :update, :destroy]
    resources :chat_scripts, only: [:new, :create, :edit, :update, :destroy]

    resources :customers, only: [:index, :show] do
      collection { post :batch_action }
    end

    resources :custom_messages do
      collection { post :batch_action }
      member { post :deliver }
    end


    resources :statistics, only: [] do
      get 'customers', on: :collection
      get 'scenario', on: :collection
      get 'connections', on: :collection
    end

    root to: 'statistics#customers'
  end

  root to: 'admin/statistics#customers'
end
