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
end