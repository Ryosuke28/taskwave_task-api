require 'rails_helper'
require 'models/shared'

RSpec.describe Task, type: :model do
  describe 'valid' do
    subject { model.valid? }

    let(:model) do
      build(:task,
            title: title,
            group_id: group_id,
            status_id: status_id,
            deadline: deadline,
            detail: detail,
            sort_number: sort_number,
            user_id: user_id)
    end
    let(:title) { 'sample_title' }
    let(:group_id) { group.id }
    let!(:group) { create(:group) }
    let(:status_id) { status.id }
    let!(:status) { create(:status, :before_start) }
    let(:deadline) { '2022-05-01' }
    let(:detail) { 'sample_detail' }
    let(:sort_number) { 1 }
    let(:user_id) { 1 }

    describe 'title' do
      context '桁数' do
        it_behaves_like '上限値の確認', 50, 'タイトルは50文字以内で入力してください' do
          let(:title) { target_column }
        end
      end

      context '必須入力' do
        it_behaves_like '必須入力の確認', 'タイトルを入力してください' do
          let(:title) { target_column }
        end
      end
    end

    describe 'group_id' do
      context '必須入力' do
        context '入力がある場合' do
          it_behaves_like :valid_true
        end

        context '空文字の場合' do
          let(:group_id) { '' }

          it_behaves_like :valid_false, 'グループを入力してください'
        end

        context 'nil の場合' do
          let(:group_id) { nil }

          it_behaves_like :valid_false, 'グループを入力してください'
        end

        context '存在しないチームIDの場合' do
          let(:group_id) { Group.last.id.next }

          it_behaves_like :valid_false, 'グループを入力してください'
        end
      end
    end

    describe 'status_id' do
      context '必須入力' do
        context '入力がある場合' do
          it_behaves_like :valid_true
        end

        context '空文字の場合' do
          let(:status_id) { '' }

          it_behaves_like :valid_false, 'ステータスを入力してください'
        end

        context 'nil の場合' do
          let(:status_id) { nil }

          it_behaves_like :valid_false, 'ステータスを入力してください'
        end

        context '存在しないチームIDの場合' do
          let(:status_id) { Status.last.id.next }

          it_behaves_like :valid_false, 'ステータスを入力してください'
        end
      end
    end

    describe 'detail' do
      context '桁数' do
        it_behaves_like '上限値の確認', 250, '詳細は250文字以内で入力してください' do
          let(:detail) { target_column }
        end
      end
    end

    describe 'sort_number' do
      context '必須入力' do
        it_behaves_like '必須入力の確認', 'ソート順を入力してください' do
          let(:sort_number) { target_column }
        end
      end
    end
  end
end
