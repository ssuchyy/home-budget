# frozen_string_literal: true

shared_examples 'returning status code' do |status_code|
  it "returns #{status_code} status code" do
    subject
    expect(response).to have_http_status(status_code)
  end
end

shared_examples 'returning error with proper error messages' do
  it 'returns error with proper error messages' do
    subject
    expect(response_body['error']).to include(*error_messages)
  end
end
