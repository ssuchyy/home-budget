# frozen_string_literal: true

def response_body
  JSON.parse(response.body)
end

def entity_json
  JSON.parse(entity.to_json)
end
