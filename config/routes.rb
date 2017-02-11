Rails.application.routes.draw do


  root :to=>'ecourt#index'

  namespace :control_panel do
    get 'stats/index'
  end

  devise_for :users

  get 'ecourt', :to=>'ecourt#index'
  get 'ecourt/districts', :as=>'ecourt_districts'
  get 'ecourt/courts', :as=>'ecourt_courts'
  match 'ecourt/search', :as=>'ecourt_search', :via=>[:get, :post]
  match 'ecourt/search/:id', :as=>'ecourt_search_results', :via=>:get, :to=>"ecourt#result"
  get 'ecourt/details', :as=>'ecourt_details'

  namespace :control_panel do
    get 'authorization', :to=>'authorization#index', :as=>'authorization_index'
    put 'authorization/:id/update', :to=>"authorization#update" , :as=>'authorization_update'
  end

  namespace :supreme_court do
    get 'case_title', :to=>'case_title#index', :as=>'case_title_index'
    match 'case_title/search', :as=>'case_title_search', :via=>[:get, :post]
    match 'case_title/search/:id', :as=>'case_title_search_results', :via=>:get, :to=>"case_title#result"
    match 'case_title/search/:id/result/:result_id/details', :as=>'case_title_search_result_details', :via=>:get, :to=>"case_title#details"
  end

  namespace :high_courts do
    namespace :bombay do
      get 'party_wise', :to=>'party_wise#index', :as=>'party_wise_index'
      match 'party_wise/search', :as=>'party_wise_search', :via=>[:get, :post]
      match 'party_wise/search/:id', :as=>'party_wise_search_results', :via=>:get, :to=>"party_wise#results"
      match 'party_wise/search/:id/result/:result_id/', :as=>'party_wise_search_result', :via=>:get, :to=>"party_wise#result"
      match 'party_wise/search/:id/result/:result_id/details/:details_id', :as=>'party_wise_search_result_details', :via=>:get, :to=>"party_wise#details"
    end
  end


  resources :searches, :only=>[:index, :show]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
