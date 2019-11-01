# frozen_string_literal: true

def response_body
  JSON.parse(response.body)
end
