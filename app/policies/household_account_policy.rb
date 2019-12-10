# frozen_string_literal: true

class HouseholdAccountPolicy
  attr_reader :user, :household_account

  def initialize(user, household_account)
    @user = user
    @household_account = household_account
  end

  def manage?
    user.household_account == household_account
  end

  def destroy?
    manage?
  end
end
