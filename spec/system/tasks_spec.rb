require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in "Tittle", with: "test"
        fill_in "Content", with: "test"
        click_button "Create Task"

        visit new_task_path
        #expect(page).to have_content "success"        
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        # テストで使用するためのタスクを登録
        #Task.create!(tittle: '書類作成', content: '企画書を作成する。')
        FactoryBot.create(:task)
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
        context '新たにタスクを作成した場合' do
            it '新しいタスクが一番上に表示される' do
          end
      end
  end

  describe '詳細表示機能1' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        visit new_task_path
        fill_in "Tittle", with: "test"
        fill_in "Content", with: "test"
        click_button "Create Task"

        task = Task.last
        visit task_path(task.id)
        expect(page).to have_content "Show Task Page"
        expect(page).to have_content task.tittle
        expect(page).to have_content task.content
       end
     end
  end
end