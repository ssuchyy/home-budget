# frozen_string_literal: true

module UserService
  class Register < BaseService
    attribute :email, Types::String
    attribute :password, Types::String

    def call
      create_user
    end

    private

    def create_user
      user = User.new(email: email, password: password)
      if user.save
        Success(user: user)
      else
        Failure(errors: user.errors.full_messages)
      end
    end
  end
end
