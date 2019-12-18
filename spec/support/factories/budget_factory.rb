# frozen_string_literal: true

FactoryBot.define do
  factory :budget do
    name { FFaker::Product.brand }
    limit { 100 }
    household_account
  end
end
