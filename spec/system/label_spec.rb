require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
  describe '登録機能' do
    context 'ラベルを登録した場合' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in 'session_email', with: 'iizuka@gmail.com'
        fill_in 'session_password', with: '0123456'
        click_button "commit"

        visit new_label_path
        end    
      it '登録したラベルが表示される' do
        visit new_label_path
        fill_in "名前", with: "label_a"
        click_button "登録する"
        expect(page).to have_content "label_a"
        expect(page).to have_content "ラベルを登録しました"
        end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      let!(:user) { FactoryBot.create(:user) }
      before do
      visit new_session_path
      fill_in 'session_email', with: 'iizuka@gmail.com'
      fill_in 'session_password', with: '0123456'
      click_button "commit"
      visit new_label_path
      end
      it '登録済みのラベル一覧が表示される' do
        visit new_label_path
        fill_in "名前", with: "label_a"
        click_button "登録する"

        visit labels_path
        #binding.irb
        expect(page).to have_content "ラベル一覧ページ"
        expect(page).to have_content "label_a"
        #expect(page).to have_content "label_b"
        #expect(page).to have_content "label_c"
      end
    end
  end

  describe 'タスク登録のテスト' do
    context 'サインアップページから情報を入力し' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in 'session_email', with: 'iizuka@gmail.com'
        fill_in 'session_password', with: '0123456'
        click_button "commit"
        visit new_label_path
        fill_in "名前", with: "label_a"
        click_button "登録する"
      end
      it "ラベルAが紐づいたタスクを生成できる" do
          visit new_task_path
          fill_in "タイトル", with: 'task1'
          fill_in "タイトル", with: "test_1"
          fill_in "内容", with: "test_01"
          fill_in "終了期限", with: "002025-05-25"
          select "中", from: "優先度"
          select "未着手", from: "ステータス"
          check 'ラベル'
          click_on('登録する')
          visit tasks_path
          expect(page).to have_content 'label_a'
      end
    end
  end

  describe 'ラベル検索のテスト' do
    context 'インデックス画面のラベル検索窓から' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in 'session_email', with: 'iizuka@gmail.com'
        fill_in 'session_password', with: '0123456'
        click_button "commit"
        visit new_label_path
        fill_in "名前", with: "label_b"
        click_button "登録する"
      end
      it "ラベルAが紐づいたタスクのみ絞り込める" do
        visit new_task_path
        fill_in "タイトル", with: 'task2'
        fill_in "タイトル", with: "test_2"
        fill_in "内容", with: "test_02"
        fill_in "終了期限", with: "002025-05-27"
        select "中", from: "優先度"
        select "未着手", from: "ステータス"
        check 'ラベル'
        click_on('登録する')

        visit tasks_path
        select "label_b", from: 'label_id'
        click_on('検索')
        expect(page).not_to have_content 'ラベルなし'
      end
    end
  end
end