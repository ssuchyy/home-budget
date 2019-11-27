# frozen_string_literal: true

shared_examples 'returning status code' do |status_code|
  it "returns #{status_code} status code" do
    subject
    expect(response).to have_http_status(status_code)
  end
end

shared_examples 'authenticating user' do
  it 'authenticates user' do
    subject
    expect(response).to have_http_status(:unauthorized)
  end
end

shared_examples 'returning error with proper error messages' do |status_code=:bad_request|
  it 'returns error with proper error messages', :aggregate_failures do
    subject
    expect(response).to have_http_status(status_code)
    expect(response_body['error']).to include(*error_messages)
  end
end
