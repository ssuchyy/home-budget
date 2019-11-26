# frozen_string_literal: true

FactoryBot.define do
  factory :household_account do
    name { FFaker::Company.name }
  end
end
