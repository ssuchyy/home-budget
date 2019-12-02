# frozen_string_literal: true

shared_examples 'returning status code' do |status_code|
  it "returns #{status_code} status code" do
    subject
    expect(response).to have_http_status(status_code)
  end
end

shared_examples 'returning 404 not found response' do |status_code|
  it 'returns 404 not found response', :aggregate_failures do
    subject
    expect(response).to have_http_status(:not_found)
    expect(response_body['error']).to eq(I18n.t('api.errors.not_found'))
  end
end

shared_examples 'returning 401 unauthorized response' do |status_code|
  it 'returns 401 unauthorized', :aggregate_failures do
    subject
    expect(response).to have_http_status(:unauthorized)
    expect(response_body['error']).to eq(I18n.t('api.errors.unauthorized'))
  end
end

shared_examples 'authenticating user' do
  it 'authenticates user' do
    subject
    expect(response).to have_http_status(:unauthorized)
  end
end

shared_examples 'returning error with proper error messages' do |status_code = :bad_request|
  it 'returns error with proper error messages', :aggregate_failures do
    subject
    expect(response).to have_http_status(status_code)
    expect(response_body['error']).to include(*error_messages)
  end
end
