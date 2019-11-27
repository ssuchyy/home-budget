# frozen_string_literal: true

shared_context 'with authenticated user' do
  let(:access_token) { create(:access_token, resource_owner_id: authenticated_user.id) }
  let(:authentication_headers) { { 'Authorization' => "Bearer #{access_token.token}" } }
end
