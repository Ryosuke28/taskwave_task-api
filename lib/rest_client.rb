require "httparty"

class RestClient
  include HTTParty
  base_uri 'http://taskwave_auth-api_1:3000'

  class << self
    # ユーザーが持っている権限を返す
    # @param [Integer] user_id ユーザーID
    # @param [Integer] team_id チームID
    # @return [String] ユーザーがチームで持っている権限
    #   一般: normal, 管理者: admin, 所有者: owner, それ以外(api実行に失敗した場合も含む): ''
    def get_user_authority(user_id, team_id)
      response = get('/api/v1/teams/user_authority', query: { user_id: user_id, team_id: team_id })

      return response.parsed_response['authority'] if response.code == 200

      ''
    end
  end
end
