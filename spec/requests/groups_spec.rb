require 'rails_helper'
require 'requests/shared'

RSpec.describe "Groups", type: :request do
  describe 'POST /api/v1/groups' do
    subject { post api_v1_groups_path, params: { group: group_params } }

    before do
      allow(RestClient).to receive(:get_user_authority).and_return(authority)
    end

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
      let(:error_code) { 'UAM_000002' }
      let(:error_messages) { ['権限がありません'] }
      let(:en_error_messages) { ["No permission"] }

      it_behaves_like 'グループは登録されない'
      it_behaves_like '正しいエラーを返す', 400
    end
  end
end
