# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
end
