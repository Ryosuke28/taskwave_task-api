module Requests
  module JsonHelpers
    def json_body
      JSON.parse(response.body).symbolize_keys
    end

    def json_array
      JSON.parse(response.body).map(&:symbolize_keys)
    end
  end
end
