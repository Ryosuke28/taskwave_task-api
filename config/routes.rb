Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :groups, only: [:create, :edit, :update, :destroy]
      resources :tasks, only: [:create, :edit, :update, :destroy]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
