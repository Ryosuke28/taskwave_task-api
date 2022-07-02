require 'rails_helper'
require 'requests/shared'

RSpec.describe "Groups", type: :request do
  describe 'POST /api/v1/groups' do
    subject { post api_v1_groups_path, params: { group: group_params } }

    before { allow(RestClient).to receive(:get_user_authority).and_return(authority) }

    let(:action_name) { 'グループ作成処理' }
    let(:en_action_name) { 'Group creation process' }

    let(:group_params) do
      {
        name: name,
        team_id: team_id
      }
    end
    let(:name) { 'test1' }
    let(:team_id) { 1 }
    let(:authority) { 'owner' }

    shared_examples 'グループは登録されない' do
      it { expect { subject }.not_to change(Group, :count) }
    end

    context 'パラメータが揃っている場合' do
      let(:expect_response) do
        {
          id: Group.last.id,
          name: name,
          team_id: team_id,
          created_at: Group.last.created_at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ"),
          updated_at: Group.last.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")
        }
      end

      it 'グループが登録される' do
        expect { subject }.to change(Group, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(json_body).to eq expect_response
      end
    end

    context 'パラメータが不足している場合' do
      let(:name) { '' }
      let(:error_code) { 'TLM_010101' }
      let(:error_messages) { ['グループ名を入力してください'] }
      let(:en_error_messages) { ["Group name can't be blank"] }

      it_behaves_like 'グループは登録されない'
      it_behaves_like '正しいエラーを返す', 400
    end

    context 'ユーザーにグループ作成権限が無い場合' do
      let(:authority) { 'normal' }
      let(:error_code) { 'TLM_000002' }
      let(:error_messages) { ['権限がありません'] }
      let(:en_error_messages) { ["No permission"] }

      it_behaves_like 'グループは登録されない'
      it_behaves_like '正しいエラーを返す', 400
    end
  end

  describe 'GET /api/v1/groups/:id/edit' do
    subject { get edit_api_v1_group_path(id: id) }

    before { allow(RestClient).to receive(:get_team_details).and_return(team_details) }

    let(:action_name) { 'グループ詳細取得処理' }
    let(:en_action_name) { 'Group detail acquisition process' }

    let!(:group) { create(:group) }
    let(:id) { group.id }
    let(:team_details) do
      {
        id: 1,
        name: 'team1',
        description: 'test1_description',
        personal_flag: true,
        created_at: '2022-04-11T13:55:44Z',
        updated_at: '2022-04-11T13:55:44Z'
      }
    end
    let(:expect_response) do
      {
        id: group.id,
        name: group.name,
        team_name: team_details[:name],
        team_description: team_details[:description],
        personal_flag: team_details[:personal_flag],
        created_at: group.created_at.strftime("%Y-%m-%dT%H:%M:%SZ"),
        updated_at: group.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")
      }
    end

    context '存在するIDの場合' do
      it 'チーム情報が返却される' do
        subject
        expect(response).to have_http_status(:ok)
        expect(json_body).to eq expect_response
      end
    end

    context '存在しないIDの場合' do
      let(:id) { Group.last.id.next }
      let(:error_code) { 'TLM_000001' }
      let(:error_messages) { ['グループは存在しません'] }
      let(:en_error_messages) { ["Group not found"] }

      it_behaves_like '正しいエラーを返す', 404
    end
  end

  describe 'PATCH /api/v1/groups/:id' do
    subject { patch api_v1_group_path(id: id), params: { group: group_params } }

    before { allow(RestClient).to receive(:get_user_authority).and_return(authority) }

    let(:action_name) { 'グループ情報更新処理' }
    let(:en_action_name) { 'Group information update process' }

    let!(:group) { create(:group) }
    let(:id) { group.id }
    let(:group_params) do
      {
        name: name,
        team_id: team_id
      }
    end
    let(:name) { 'test1' }
    let(:team_id) { group.team_id }
    let(:authority) { 'owner' }
    let(:expect_response) do
      {
        id: group.reload.id,
        name: name,
        team_id: team_id,
        created_at: group.created_at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ"),
        updated_at: group.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")
      }
    end

    context '存在するIDの場合' do
      it 'チーム情報が返却される' do
        subject
        expect(response).to have_http_status(:ok)
        expect(json_body).to eq expect_response
      end
    end

    context 'チームIDを変更する場合' do
      let(:team_id) { group.team_id.next }
      let(:error_code) { 'TLM_010301' }
      let(:error_messages) { ['チームIDは変更できません'] }
      let(:en_error_messages) { ["Team ID cannot change"] }

      it_behaves_like '正しいエラーを返す', 400
    end

    context 'ユーザーにグループ更新権限が無い場合' do
      let(:authority) { 'normal' }
      let(:error_code) { 'TLM_000002' }
      let(:error_messages) { ['権限がありません'] }
      let(:en_error_messages) { ["No permission"] }

      it_behaves_like '正しいエラーを返す', 400
    end

    context '存在しないIDの場合' do
      let(:id) { Group.last.id.next }
      let(:error_code) { 'TLM_000001' }
      let(:error_messages) { ['グループは存在しません'] }
      let(:en_error_messages) { ["Group not found"] }

      it_behaves_like '正しいエラーを返す', 404
    end
  end

  describe 'PATCH /api/v1/groups/:id' do
    subject { delete api_v1_group_path(id: id) }

    before { allow(RestClient).to receive(:get_user_authority).and_return(authority) }

    let(:action_name) { 'グループ削除処理' }
    let(:en_action_name) { 'Group deletion process' }

    let!(:group) { create(:group) }
    let(:id) { group.id }
    let!(:task) { create(:task, :status_before_start, group: group) }
    let(:authority) { 'owner' }

    context '存在するIDの場合' do
      it 'チームが削除される' do
        expect { subject }.to change(Group, :count).by(-1).and change(Task, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context '存在しないIDの場合' do
      let(:id) { Group.last.id.next }
      let(:error_code) { 'TLM_000001' }
      let(:error_messages) { ['グループは存在しません'] }
      let(:en_error_messages) { ["Group not found"] }

      it_behaves_like '正しいエラーを返す', 404
    end

    context 'ユーザーにグループ削除権限が無い場合' do
      let(:authority) { 'normal' }
      let(:error_code) { 'TLM_000002' }
      let(:error_messages) { ['権限がありません'] }
      let(:en_error_messages) { ["No permission"] }

      it_behaves_like '正しいエラーを返す', 400
    end
  end
end
