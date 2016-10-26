class ApplicationController < Spud::ApplicationController
  protect_from_forgery with: :exception
end
