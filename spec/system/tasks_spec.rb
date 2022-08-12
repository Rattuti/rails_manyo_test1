require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in "タイトル", with: "test"
        fill_in "内容", with: "test"
        click_button "登録する"
        expect(page).to have_content "Show"
      end
    end
  end

  describe '一覧表示機能' do
# let!を使ってテストデータを変数として定義することで、複数のテストでテストデータを共有できる
    let!(:first_task) { FactoryBot.create(:first_task) }
    let!(:second_task) { FactoryBot.create(:second_task) }
    let!(:third_task) { FactoryBot.create(:third_task) }
    before do
        visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'test3'
        expect(task_list[1]).to have_content '書類作成'
        expect(task_list[2]).to have_content 'test1'
      end
    end
        context '新たにタスクを作成した場合' do
            it '新しいタスクが一番上に表示される' do
              task_list = all('tbody tr')
              expect(task_list[0]).to have_content 'test3'
          end
      end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
       task = Task.last
        visit task_path(task.id)
        expect(page).to have_content "Show Task Page"
        expect(page).to have_content task.tittle
        expect(page).to have_content task.content
       end
     end
  end
end