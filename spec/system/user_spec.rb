require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in "user[name]", with: "hatakeyama"
        fill_in "user[email]", with: "hayakeyama@gmail.com"
        fill_in "user[password]", with: "hatakeyama"
        fill_in "user[password_confirmation]", with: "hatakeyama"
        click_button "commit"
        expect(page).to have_content("ユーザを登録しました")
      end
    end
    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content("ログインしてください")
      end
    end
  end

  describe 'ログイン機能' do
    let!(:first_user) { FactoryBot.create(:user) }
    let!(:second_user) { FactoryBot.create(:second_user) }
    context '登録済みのユーザでログインした場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: "thomas@gmail.com"
        fill_in "session[password]", with: "123456"
        click_button "commit"
      end

      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_content "ログインしました"
      end
      it '自分の詳細画面にアクセスできる' do
        click_link "アカウント詳細"
        expect(page).to have_content "アカウント詳細ページ"
      end
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        user = User.find_by(name: "Mike")
        visit user_path(user.id)
        expect(page).to have_content "アクセス権限がありません"
      end
      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link "ログアウト"
        expect(page).to have_content "ログアウトしました"
      end
    end
  end

  describe '管理者機能' do
    let!(:third_user) { FactoryBot.create(:third_user) }
    let!(:first_user) { FactoryBot.create(:fourth_user) }
    context '管理者がログインした場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: "taylor@gmail.com"
        fill_in "session[password]", with: "123456"
        click_button "commit"
      end
      it 'ユーザ一覧画面にアクセスできる' do
        click_link "ユーザ一覧"
        expect(page).to have_content "ユーザ一覧ページ"
      end
      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in "user[name]", with: "Chris"
        fill_in "user[email]", with: "chris@gmail.com"
        fill_in "user[password]", with: "123456"
        fill_in "user[password_confirmation]", with: "123456"
        check "user[admin]"
        click_button "commit"
        expect(page).to have_content "ユーザを登録しました"
      end
      it 'ユーザ詳細画面にアクセスできる' do
        user = User.first
        visit admin_user_path(user.id)
        expect(page).to have_content "ユーザ詳細ページ"
      end
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        click_link "アカウント詳細"
        click_link "編集"
        fill_in "user[name]", with: "Christpher"
        fill_in "user[password]", with: "123456"
        fill_in "user[password_confirmation]", with: "123456"
        click_button "commit"
        expect(page).to have_content "アカウント詳細ページ"
      end
      it 'ユーザを削除できる' do
        visit admin_users_path
        click_link "削除", match: :first
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "ユーザを削除しました"
      end
    end
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit new_session_path
        fill_in "session[email]", with: "nancy@gmail.com"
        fill_in "session[password]", with: "123456"
        click_button "commit"
        visit admin_users_path
        expect(page).to have_content "管理者以外はアクセスできません"
      end
    end
  end
end