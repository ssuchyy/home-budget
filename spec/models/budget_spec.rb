# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Budget, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:household_account_id) }
end
