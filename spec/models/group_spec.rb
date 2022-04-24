require 'rails_helper'
require 'models/shared'

RSpec.describe Group, type: :model do
  describe 'valid' do
    subject { model.valid? }

    let(:model) { build(:group, name: name, team_id: team_id) }
    let(:name) { 'sample_name' }
    let(:team_id) { 1 }

    describe 'name' do
      context '桁数' do
        it_behaves_like '上限値の確認', 50, 'グループ名は50文字以内で入力してください' do
          let(:name) { target_column }
        end
      end

      context '必須入力' do
        it_behaves_like '必須入力の確認', 'グループ名を入力してください' do
          let(:name) { target_column }
        end
      end

      context '複合ユニーク制約' do
        before { create(:group, name: name, team_id: team_id) }

        it do
          is_expected.to eq false
          expect(model.errors.full_messages).to include 'グループ名はすでに存在します'
        end
      end
    end

    describe 'team_id' do
      context '必須入力' do
        it_behaves_like '必須入力の確認', 'チームIDを入力してください' do
          let(:team_id) { target_column }
        end
      end
    end
  end
end
