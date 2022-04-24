module Api
  module V1
    class GroupsController < ApplicationController
      before_action :check_action_user

      # グループ作成
      # POST /api/v1/groups
      def create
        group = Group.new(group_params)

        if group.save
          render_json group
        else
          render_problem('TLM_010101', group.errors.full_messages)
        end
      end

      private

      def group_params
        params.require(:group).permit(:name, :team_id)
      end

      # チームに対して権限を持っているユーザーか確認する
      def check_action_user
        # authority = RestClient.get_user_authority(JSON.parse(request.headers['UserId']), params.dig(:group, :team_id))
        authority = RestClient.get_user_authority(request.headers['UserId'], params.dig(:group, :team_id))

        raise Exceptions::PermissionError unless Group::AUTHORITY_ADMIN.include?(authority)
      end
    end
  end
end
