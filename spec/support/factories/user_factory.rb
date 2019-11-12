# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.unique.email }
    password { FFaker::Internet.unique.password }
  end
end
