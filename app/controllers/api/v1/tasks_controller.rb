module Api
  module V1
    class TasksController < ApplicationController
      before_action :check_action_user

      # タスク作成
      # POST /api/v1/tasks
      def create
        task = Task.new(task_params)

        if task.save
          render_json task
        else
          render_problem('TLM_020101', task.errors.full_messages)
        end
      end

      private

      def task_params
        params.require(:task).permit(:title, :group_id, :status_id, :deadline, :detail, :user_id)
      end

      # チームに対して権限を持っているユーザーか確認する
      def check_action_user
        team_id = Group.find(params.dig(:task, :group_id)).team_id

        # authority = RestClient.get_user_authority(JSON.parse(request.headers['UserId']), params.dig(:group, :team_id))
        authority = RestClient.get_user_authority(request.headers['UserId'], team_id)

        raise Exceptions::PermissionError unless Group::AUTHORITY_ADMIN.include?(authority)
      end
    end
  end
end
