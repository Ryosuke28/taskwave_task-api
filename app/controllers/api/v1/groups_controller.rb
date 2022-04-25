module Api
  module V1
    class GroupsController < ApplicationController
      before_action :check_action_user, only: [:create, :update, :destroy]
      before_action :find_group, only: [:edit, :update, :destroy]

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

      # グループ詳細
      # GET /api/v1/groups/:id/edit
      def edit
        render_json @group.hash_for_edit
      end

      # グループ更新
      # PATCH /api/v1/groups/:id
      def update
        @group.assign_attributes(group_params)

        if @group.save
          render_json @group
        else
          render problem: {
            title: I18n.t('action.groups.update'),
            error_code: 'TLM_010301',
            error_message: @group.errors.full_messages
          }, status: :bad_request
        end
      end

      # グループ削除
      # DELETE /api/v1/groups/:id
      def destroy
        @group.destroy
        render_json({})
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

      def find_group
        @group = Group.find(params[:id])
      end
    end
  end
end
