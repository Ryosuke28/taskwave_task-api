RSpec.shared_examples :valid_true do
  it { is_expected.to eq true }
end

RSpec.shared_examples :valid_false do |message|
  it do
    is_expected.to eq false
    expect(model.errors.full_messages).to include message
  end
end

RSpec.shared_examples '上限値の確認' do |max, message|
  context '上限値の場合' do
    let(:target_column) { 'a' * max }

    it_behaves_like :valid_true
  end

  context '上限値 +1 の場合' do
    let(:target_column) { 'a' * (max + 1) }

    it_behaves_like :valid_false, message
  end
end

RSpec.shared_examples '下限値の確認' do |message|
  let(:target_column) { 'a' * 32 }

  context '下限値の場合' do
    let(:target_column) { 'a' * 1 }

    it_behaves_like :valid_true
  end

  context '下限値 -1 の場合' do
    let(:target_column) { 'a' * 0 }

    it_behaves_like :valid_false, message
  end
end

RSpec.shared_examples '必須入力の確認' do |message|
  context '入力がある場合' do
    let(:target_column) { 'sample' }

    it_behaves_like :valid_true
  end

  context '空文字の場合' do
    let(:target_column) { '' }

    it_behaves_like :valid_false, message
  end

  context '空白の場合' do
    let(:target_column) { ' ' }

    it_behaves_like :valid_false, message
  end

  context 'nil の場合' do
    let(:target_column) { nil }

    it_behaves_like :valid_false, message
  end
end
