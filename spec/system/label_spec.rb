require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  before do
    visit new_session_path
    fill_in "session[email]", with:"wada@gmail.com"
    fill_in "session[password]", with:"0123456"
    binding.irb
    click_button "commit"
  end

  describe '登録機能' do
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        visit new_label_path
        fill_in "名前", with: "label_name"
        click_button "登録する"
        expect(page).to have_content "label_name"
        expect(page).to have_content "ラベルを登録しました"
        end
    end
  end

  describe '一覧表示機能' do
    let!(:first_label) { FactoryBot.create(:label, user_id: user.id) }
    let!(:second_label) { FactoryBot.create(:second_label, user_id: first_label.user_id) }
    let!(:third_label) { FactoryBot.create(:third_label, user_id: first_label.user_id) }
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        visit labels_path
        expect(page).to have_content "label_1"
        expect(page).to have_content "label_2"
        expect(page).to have_content "label_3"
      end
    end
  end
end