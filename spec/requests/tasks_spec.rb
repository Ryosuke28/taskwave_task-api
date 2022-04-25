require 'rails_helper'
require 'requests/shared'

RSpec.describe "Tasks", type: :request do
  include_context 'ステータスデフォルトデータ作成'

  describe 'POST /api/v1/tasks' do
    subject { post api_v1_tasks_path, params: { task: task_params } }

    before { allow(RestClient).to receive(:get_user_authority).and_return(authority) }

    let(:action_name) { 'タスク作成処理' }
    let(:en_action_name) { 'Task creation process' }

    let(:task_params) do
      {
        title: title,
        group_id: group_id,
        status_id: status_id,
        deadline: deadline,
        detail: detail,
        user_id: user_id
      }
    end
    let(:title) { 'title1' }
    let(:group) { create(:group) }
    let(:group_id) { group.id }
    let(:status_id) { 1 }
    let(:deadline) { '2022-05-01' }
    let(:detail) { 'sample_detail' }
    let(:sort_number) { 1 }
    let(:user_id) { 1 }
    let(:authority) { 'owner' }

    shared_examples 'タスクは登録されない' do
      it { expect { subject }.not_to change(Task, :count) }
    end

    context 'パラメータが揃っている場合' do
      let(:expect_response) do
        {
          id: Task.last.id,
          title: title,
          group_id: group_id,
          status_id: status_id,
          deadline: deadline,
          detail: detail,
          sort_number: sort_number,
          user_id: user_id,
          created_at: Task.last.created_at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ"),
          updated_at: Task.last.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")
        }
      end

      context 'タスクの登録がない場合' do
        it 'グループが登録される' do
          expect { subject }.to change(Task, :count).by(1)
          expect(response).to have_http_status(:ok)
          expect(json_body).to eq expect_response
        end
      end

      context 'タスクの登録がある場合' do
        before { sample_task }

        let(:sample_task) { create(:task, :status_before_start, group: group) }
        let(:sort_number) { sample_task.sort_number.next }

        it 'グループが登録される' do
          expect { subject }.to change(Task, :count).by(1)
          expect(response).to have_http_status(:ok)
          expect(json_body).to eq expect_response
        end
      end
    end

    context 'パラメータが不足している場合' do
      let(:title) { '' }
      let(:error_code) { 'TLM_020101' }
      let(:error_messages) { ['タイトルを入力してください'] }
      let(:en_error_messages) { ["Title can't be blank"] }

      it_behaves_like 'タスクは登録されない'
      it_behaves_like '正しいエラーを返す', 400
    end

    context 'ユーザーにグループ作成権限が無い場合' do
      let(:authority) { 'normal' }
      let(:error_code) { 'UAM_000002' }
      let(:error_messages) { ['権限がありません'] }
      let(:en_error_messages) { ["No permission"] }

      it_behaves_like 'タスクは登録されない'
      it_behaves_like '正しいエラーを返す', 400
    end
  end
end
