Rails.application.routes.draw do
  mount HomeBudget::API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
