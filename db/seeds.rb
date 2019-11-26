# frozen_string_literal: true

require 'ffaker'

# Create users

john_doe = User.create(email: 'john_doe@example.com', password: 'password')
User.create(email: 'johnatan_pear@example.com', password: 'password')

# Create household accounts

account = HouseholdAccount.create(name: FFaker::Company.name)
account.users << john_doe
