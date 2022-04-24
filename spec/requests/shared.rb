RSpec.shared_context 'ステータスデフォルトデータ作成' do
  before do
    Status.first_or_create([
                             { id: 1, name: 'before_start', description: '着手前' },
                             { id: 2, name: 'working', description: '作業中' },
                             { id: 3, name: 'finish', description: '完了' }
                           ])
  end
end

# action_name, error_code, error_messagesは事前に定義しておく
RSpec.shared_examples '正しいエラーを返す' do |status|
  context '日本語の場合' do
    it do
      subject
      expect(json_body[:title]).to eq action_name
      expect(json_body[:status]).to eq status
      expect(json_body[:error_code]).to eq error_code
      expect(json_body[:error_message]).to eq error_messages
    end
  end

  context '英語の場合' do
    around do |example|
      I18n.locale = :en
      example.run
      I18n.locale = :ja
    end

    it do
      subject
      expect(json_body[:title]).to eq en_action_name
      expect(json_body[:status]).to eq status
      expect(json_body[:error_code]).to eq error_code
      expect(json_body[:error_message]).to eq en_error_messages
    end
  end
end
