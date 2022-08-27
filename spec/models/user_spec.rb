require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: "", email: "iizuka@gmail.com", password: "0123456", admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: "Iizuka", email: "", password: "0123456", admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: "Iizuka", email: "iizuka@gmail.com", password: "", admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: "Iizuka", email: "iizuka@gmail.com", password: "0123456", admin: false)
        user2 = User.create(name: "Thomas", email: "iizuka@gmail.com", password: "0123456", admin: false)
        expect(user2).not_to be_valid
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: "Iizuka", email: "iizuka@gmail.com", password: "0123", admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = User.create(name: "Yamada", email: "yamada@gmail.com", password: "yamadasukusuku")
        expect(user).to be_valid
      end
    end
  end
end