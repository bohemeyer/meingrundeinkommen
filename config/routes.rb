Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations', passwords: 'passwords' }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'websites#show'

  namespace :api, defaults: {format: :json} do
    resources :registrations
    resources :chances
    resources :comments
    resources :supports
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
  end
  resources :users
  resources :payments

  # Catch all missing templates
  get 'assets/*page' => redirect('assets/missing.html')

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
