# frozen_string_literal: true

require 'rails_helper'

describe HouseholdAccountService::InviteUsers, type: :service do
  describe '#call' do
    subject(:service_call) do
      described_class.new(household_account: household_account, users_emails: emails).call
    end

    let(:household_account) { build_stubbed(:household_account) }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    shared_examples 'sending invitation to all provided emails' do
      it 'sends invitation to all provided emails', :aggregate_failures do
        emails.each do |email|
          expect(User)
            .to receive(:invite!)
            .with(email: email, household_account: household_account)
        end
        service_call
      end
    end

    context 'when there are no existing users emails in provided emails' do
      let(:emails) { ['asd1@example.com', 'asd2@example.com'] }

      it_behaves_like 'sending invitation to all provided emails'
    end

    context 'when one of the emails belongs to existing user' do
      context 'when existing user does not have household account yet' do
        let(:user) { create(:user) }
        let(:emails) { [user.email, 'new_email@example.com'] }

        it_behaves_like 'sending invitation to all provided emails'
      end

      context 'when existing user already have household account' do
        let(:user) { create(:user, :with_household_account) }
        let(:emails) { [user.email, new_user_email] }
        let(:new_user_email) { 'new_email@example.com' }

        it 'does not send invitation for user with household account' do
          expect(User)
            .to_not receive(:invite!)
            .with(email: user.email, household_account: household_account)
          service_call
        end

        it 'sends invitation for new user email' do
          expect(User)
            .to receive(:invite!)
            .with(email: new_user_email, household_account: household_account)
          service_call
        end
      end
    end
  end
end
