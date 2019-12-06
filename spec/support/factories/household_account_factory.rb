# frozen_string_literal: true

FactoryBot.define do
  factory :household_account do
    name { FFaker::Company.name }

    trait :with_user do
      after(:create) do |household_account|
        household_account.users << create(:user)
      end
    end
  end
end
