# frozen_string_literal: true

FactoryBot.define do
  factory :budget do
    name { FFaker::Product.brand }
    household_account
  end
end
