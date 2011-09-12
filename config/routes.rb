Todo31::Application.routes.draw do
  resources :tasks do
    member do
      put 'complete'
    end
  end

  resources :category
  root :to => 'tasks#index'
end
