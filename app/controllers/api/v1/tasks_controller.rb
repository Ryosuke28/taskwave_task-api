module Api
  module V1
    class TasksController < ApplicationController
      before_action :check_admin_user?, only: [:create]
      before_action :find_task, only: [:edit, :update, :destroy]

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

      # タスク詳細
      # GET /api/v1/tasks/:id/edit
      def edit
        check_team_user(@task)
        render_json @task.hash_for_edit
      end

      # タスク更新
      # PATCH /api/v1/tasks/:id
      def update
        check_update_user(@task)
        @task.assign_attributes(task_params)

        if @task.save
          render_json @task
        else
          render problem: {
            title: I18n.t('action.tasks.update'),
            error_code: 'TLM_010201',
            error_message: @task.errors.full_messages
          }, status: :bad_request
        end
      end

      # タスク削除
      # DELETE /api/v1/tasks/:id
      def destroy
        check_delete_user(@task)
        @task.destroy
        render_json({})
      end

      private

      def task_params
        params.require(:task).permit(:title, :group_id, :status_id, :deadline, :detail, :user_id)
      end

      # チームに対して管理者権限を持っているユーザーか確認する
      def check_admin_user?
        team_id = Group.find(params.dig(:task, :group_id)).team_id

        # authority = RestClient.get_user_authority(JSON.parse(request.headers['UserId']), params.dig(:group, :team_id))
        authority = RestClient.get_user_authority(request.headers['UserId'], team_id)

        raise Exceptions::PermissionError unless Group::AUTHORITY_ADMIN.include?(authority)
      end

      # チームに対して一般権限を持っているユーザーか確認する
      # @param [Task] task タスクのインスタンス
      def check_team_user(task)
        team_id = task.group.team_id

        # authority = RestClient.get_user_authority(JSON.parse(request.headers['UserId']), params.dig(:group, :team_id))
        authority = RestClient.get_user_authority(request.headers['UserId'], team_id)

        raise Exceptions::PermissionError unless Group::AUTHORITY_NORMAL.include?(authority)
      end

      # タスクの編集権限を持っているユーザーか確認する
      # チームの管理者ユーザー以上、アサインされている一般ユーザー：可能、それ以外：不可
      # @param [Task] task タスクのインスタンス
      def check_update_user(task)
        return if task.user_id == request.headers['UserId']

        team_id = task.group.team_id
        # authority = RestClient.get_user_authority(JSON.parse(request.headers['UserId']), params.dig(:group, :team_id))
        authority = RestClient.get_user_authority(request.headers['UserId'], team_id)

        raise Exceptions::PermissionError unless Group::AUTHORITY_ADMIN.include?(authority)
      end

      # タスクの削除権限を持っているユーザーか確認する
      # @param [Task] task タスクのインスタンス
      def check_delete_user(task)
        team_id = task.group.team_id

        # authority = RestClient.get_user_authority(JSON.parse(request.headers['UserId']), params.dig(:group, :team_id))
        authority = RestClient.get_user_authority(request.headers['UserId'], team_id)

        raise Exceptions::PermissionError unless Group::AUTHORITY_ADMIN.include?(authority)
      end

      def find_task
        @task = Task.find(params[:id])
      end
    end
  end
end
