require 'rails_helper'

RSpec.describe 'ラベルモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ラベルの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
       label = Label.new(name: "")
       label.save
       expect(label).not_to be_valid
      end
    end

    context 'ラベルの名前に値があった場合' do
      it 'バリデーションに成功する' do
       label = Label.new(name: "label_1")
       user = User.new(name: "Mike", email: "adc@gmail.com", password: "123456", admin: false)
       user.save!
       label.user_id = user.id
       label.save!
       expect(label).to be_valid
      end
    end
  end
end