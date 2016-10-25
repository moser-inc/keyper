Rails.application.routes.draw do
  mount TbApi::Engine => "/tb_api"
end
