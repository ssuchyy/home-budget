Rails.application.routes.draw do
  use_doorkeeper
  # devise_for :users
  mount HomeBudget::API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
