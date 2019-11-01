Rails.application.routes.draw do
  # devise_for :users
  mount HomeBudget::API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
