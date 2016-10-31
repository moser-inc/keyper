Keyper::Engine.routes.draw do
  scope module: :keyper do
    resources :api_keys, only: [:index, :create, :destroy] do
      post :check, on: :collection
    end
  end
end
