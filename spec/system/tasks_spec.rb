require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
    #before do
        #driven_by(:selenium_chrome_headless)
    #end
    describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_user_path
        fill_in "タイトル", with: "qwe"
        fill_in "メールアドレス", with: "qwe@gmail.com"
        fill_in "パスワード", with: "012345"
        fill_in "パスワード(確認)", with: "012345"
        click_button "登録する"
        visit new_task_path
        fill_in "タイトル", with: "test0"
        fill_in "内容", with: "test01"
        fill_in "終了期限", with: "2025-05-25"
        select "中", from: "優先度"
        select "未着手", from: "ステータス"
        click_button "登録する"
        expect(page).to have_content "タスクを登録しました"
      end
    end
  end

  describe '一覧表示機能' do
# let!を使ってテストデータを変数として定義することで、複数のテストでテストデータを共有できる
    before do
      task1 = FactoryBot.create(:first_task) 
      task2 = FactoryBot.create(:second_task, user_id: task.user.id) 
      task3 = FactoryBot.create(:third_task, user_id: task.user.id) 
      visit new_session_path
      fill_in 'session[email]', with: "test@gmail.com"
      fill_in 'session[password]', with: "012345"
      click_button 'commit'
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'test3'
        expect(task_list[1]).to have_content 'test2'
        expect(task_list[2]).to have_content 'test1'
      end
    end

        context '新たにタスクを作成した場合' do
            it '新しいタスクが一番上に表示される' do
              task_list = all('tbody tr')
              expect(task_list[0]).to have_content 'test3'
          end
      end

      describe 'ソート機能' do
      context '「優先度でソートする」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          click_link '優先度'
          expect(Task.all.to_a).to match_array([first_task,second_task,third_task])
        end
      end
    end
    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          fill_in 'タイトル', with: '学習'
          click_button '検索'
          expect(page).to have_content("現場Railsを読む")
          expect(page).not_to have_content("バイト")
          expect(page).not_to have_content("家事")
        end
      end
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          select '未着手', from: 'ステータス'
          click_button '検索'
          expect(page).to have_content("学習")
          expect(page).not_to have_content("家事")
          expect(page).not_to have_content("バイト")
        end
      end
      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          fill_in 'タイトル', with: 'バイト'
          select '着手中', from: 'ステータス'
          click_button '検索'
          expect(page).to have_content("日勤")
          expect(page).not_to have_content("学習")
          expect(page).not_to have_content("家事")
        end
      end
    end
  end

  describe '詳細表示機能' do
    before do
      task = FactoryBot.create(:first_task) 
      FactoryBot.create(:second_task, user_id: task.user.id)
      FactoryBot.create(:third_task, user_id: task.user.id)
      visit new_session_path
      fill_in "session[email]", with: "test@gmail.com"
      fill_in "session[password]", with: "012345"
      click_button "commit"
      visit tasks_path
    end


    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        task = Task.last
        visit task_path(task.id)
        expect(page).to have_content "タスク詳細ページ"
        expect(page).to have_content task.title
        expect(page).to have_content task.content
      end
    end
  end
end