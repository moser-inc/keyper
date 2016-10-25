Rails.application.routes.draw do
  mount TbApiKeys::Engine => "/tb_api_keys"
end
