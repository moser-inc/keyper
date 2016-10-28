TbApi::Engine.routes.draw do
  scope module: :tb_api do
    resources :api_keys, only: [:index, :create, :destroy] do
      get :check, on: :collection
    end
  end
end
