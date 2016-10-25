module TbApi::HasApiKeys
  extend ActiveSupport::Concern

  included do
    has_many :api_keys, class_name: 'TbApi', dependent: :destroy
  end
end
