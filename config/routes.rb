Rails.application.routes.draw do
  devise_for :users
  resources :leftovers
  resources :days
  resources :subprocesses
  resources :measurements
  resources :standards
  resources :machines
  resources :procedures

  resources :routes
  resources :has_leftovers
  # resources :orders 
  # resources :order_comments

  resources :orders do
    resources :order_comments
    # get 'change_state/:action' => 'orders#change_state', as: :change_state_order

  end
  # resources :orders do
  #   resources :subprocesses, only:[:index,:show,:create,:update]
  # end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  #route for create standard references one machine
  get 'standards/new/:ref' => 'standards#new', as: :new_standard_machine_ref
  #route for create day references one machine
  get 'days/new/:ref' => 'days#new', as: :new_day_machine_ref
  #interface for get orders from khronos

  get 'get_orders' => 'orders#get'
  #route for programm at order
  get 'orders/:id/schedule' => 'orders#schedule', as: :schedule_order
  #route for calculate meters by quantity
  post 'calculate_meters' => 'orders#calculate_meters'
  #route for create subprocess of order
  get 'new_subprocesses/:id' => 'orders#new_subprocess', as: :new_order_subprocesses
  # route for change state of order by param
  get 'orders/:id/change_state/:state' => 'orders#change_state', as: :change_state_order
  # route for approve order
  get 'approve_order/:id' => 'orders#approve_order'

  #route where it's do order "drag on drop"
  get 'machines/:id/sorting' => 'machines#sorting', as: :sort_subprocess

  #route where it's do order "drag on drop"
  get 'machines/:id/todo' => 'machines#todo', as: :todo_subprocess

  #route delivery leftovers availables by sheet_id
  get 'leftovers/by_sheet/:sheet_id' => 'leftovers#by_sheet'

  #route 
  get 'schedule_days/:machine_id' => 'days#schedule', as: :schedule_days

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
