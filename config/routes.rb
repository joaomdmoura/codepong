Codepong::Application.routes.draw do
  resources :matches

  resources :players

  root :to => 'players#index'
  match 'player/match/:id' => 'players#match', :as => :player_match
  match 'match_definition' => 'players#match_definition', :as => :match_definition
  match 'match/confirm/:hash' => 'matches#confirm_result', :as => :confirm_match
  match 'match/give_up/:hash' => 'matches#give_up', :as => :give_up_match
  match 'matches/player/:id' => 'matches#show', :as => :player_macthes
  match 'matches/denounce/:id' => 'matches#denounce', :as => :denounce_match
  match 'player/challenge/:id' => 'players#challenge', :as => :challenge_player
  match 'match_challenge' => 'players#challenge_defined'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
