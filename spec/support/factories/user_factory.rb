# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.unique.email }
    password { FFaker::Internet.unique.password }

    trait :with_household_account do
      association :household_account
    end
  end
end
