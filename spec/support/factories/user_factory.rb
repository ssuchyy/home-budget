# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.unique.email }
    password { FFaker::Internet.unique.password }

    trait :with_household_account do
      association :household_account
    end

    factory :invited_user do
      after(:create) do |user|
        user.invite! do |user|
          user.skip_invitation = true
        end
      end

      trait :with_accepted_invitation do
        after(:create) { |user| user.accept_invitation! }
      end
    end
  end
end
