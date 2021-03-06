Rails.application.routes.draw do
  resources :app_settings, only: [:edit,:update]
  resources :modifications do
    resources :modification_comments, only: [:index,:new,:create]
    resources :modification_attachments, only: [:new,:create,:destroy]
  end
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
    resources :modifications
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
  # route for remove subprocesses of order
  delete 'orders/:id/remove_subprocesses' => 'orders#remove_subprocesses', as: :remove_subprocesses
  # route for rereapprove one order
  get 'orders/:id/reactivate' => 'orders#m_reactivate'
  # router for search order
  get 'orders_search' => 'orders#search'
  # router for filter search order
  post 'orders_search' => 'orders#search_filter'
  #
  get 'orders_by_number/:order_number' => 'orders#by_number'


  #route where it's do order "drag on drop"
  get 'machines/:id/sorting' => 'machines#sorting', as: :sort_subprocess

  #route where it's do order "drag on drop"
  get 'machines/:id/todo' => 'machines#todo', as: :todo_subprocess

  #route delivery leftovers availables by sheet_id
  get 'leftovers/by_sheet/:sheet_id' => 'leftovers#by_sheet'

  #route 
  get 'schedule_days/:machine_id' => 'days#schedule', as: :schedule_days

  put 'modifications/:id/approve'=> 'modifications#m_approve', as: :approve_modification
  put 'modifications/:id/refuse'=> 'modifications#m_refuse', as: :refuse_modification
  # this method is used to mark a modification as unread
  put 'modifications/:id/mark_unread'=> 'modifications#mark_as_unread', as: :mark_as_unread
  # this method is used to mark a modifications as executed
  put 'modifications/:id/mark_as_executed'=> 'modifications#mark_as_executed', as: :mark_as_executed

  post 'modifications/:id/upload_file' => 'modification_attachments#create'

  get 'subprocesses_machine/:machine_id' => 'subprocesses#by_machine'
  # method for move subprocesses to machine
  put 'subprocesses/:id/move_machine/:machine_id' => 'subprocesses#move_machine'


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
