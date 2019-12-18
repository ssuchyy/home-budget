# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    amount { 100 }
    budget
  end
end
