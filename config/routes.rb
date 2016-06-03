Rails.application.routes.draw do

  resources :settings

  resources :codes

  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations', passwords: 'passwords' }


devise_scope :user do
  get "/login", :to => "devise/sessions#new"
  get "/register", :to => "registrations#new"
end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'websites#show'

  namespace :api, defaults: {format: :json} do
    resource :crowdbar
    resources :tandems
    resources :settings
    resources :codes
    resources :crowdcards
    resources :flags
    resources :statistics
    resources :notifications
    resources :registrations
    resources :twitter_chances
    resources :chances
    resources :comments
    resources :supports do
      collection do
        get 'statements'
        get 'crowdbar'
      end
    end
    resources :payments
    resources :drawings
    resources :questions
    resources :todos
    resources :states do
      member do
        get :stories
        get :users
        get :states
        get :wishes
      end
    end
    resources :wishes do
      collection do
        get 'top'
      end
      member do
        get :users
        get :stories
        get :states
        get :wishes
      end
    end
    resources :user_wishes
    resources :state_users
    resources :winners
    resources :users do
      member do
        get :states
        get :wishes
        get :suggestions
      end
    end
    resource :homepages
    resources :mailings
  end
  resources :users

  resources :payments
  resource :crowdapp
  resources :subscriptions


  # Temp for the german language
  get 'languages/deDE.json', to: 'languages#de'

  # Catch all missing templates
  get 'assets/*page' => redirect('assets/missing.html')

  get "/404", :to => "errors#custom"
  get "/422", :to => "errors#custom"
  get "/500", :to => "errors#custom"


  # Angular catch all to allow page refresh
  get '*page' => "websites#show"

  #get '*path' => "websites#show"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
