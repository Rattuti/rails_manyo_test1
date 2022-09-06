require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  before do
    visit new_session_path
    fill_in "session[email]", with:"wada@gmail.com"
    fill_in "session[password]", with:"0123456"
    binding.irb
    click_button "commit"
  end
  #before do
        #driven_by(:selenium_chrome_headless)
    #end
    describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_user_path
        fill_in "名前", with: "qwe"
        fill_in "メールアドレス", with: "qwe@gmail.com"
        fill_in "パスワード", with: "0123456"
        fill_in "パスワード(確認)", with: "0123456"
        click_button "登録する"
        visit new_task_path
        fill_in "タイトル", with: "test0"
        fill_in "内容", with: "test01"
        fill_in "終了期限", with: "002025-05-25"
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
      task = FactoryBot.create(:third_task) 
      task2 = FactoryBot.create(:fourth_task, user_id: task.user.id) 
      task3 = FactoryBot.create(:fifth_task, user_id: task.user.id) 

      visit new_session_path
      fill_in "session[email]", with:"wada@gmail.com"
      fill_in "session[password]", with:"0123456"
      click_button "commit"

      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content "test5"
        expect(task_list[1]).to have_content "test4"
        expect(task_list[2]).to have_content "test3"
        #binding.irb
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
        fill_in "task[tittle]", with: "おつかい"
        fill_in "task[content]", with: "ららぽーとへ"
        fill_in "task[deadline_on]", with: '002025-02-18'
        select "中", from: "task[priority]"
        select "未着手", from: "task[status]"
        click_button "commit"

        visit tasks_path
        #binding.irb
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content "おつかい"
      end
    end

      describe 'ソート機能' do
        context '「終了期限でソートする」というリンクをクリックした場合' do
          it "終了期限昇順に並び替えられたタスク一覧が表示される" do
            click_link '終了期限'
            task_list = page.all('tbody tr')
            expect(task_list[0]).to have_content "task3"
            expect(task_list[1]).to have_content "task4"
            expect(task_list[2]).to have_content "task5"
          end
        end
        context '「優先度でソートする」というリンクをクリックした場合' do
          it "優先度の高い順に並び替えられたタスク一覧が表示される" do
            click_link '優先度'
            task_list = page.all('tbody tr')
            expect(task_list[0]).to have_content "task5"
            expect(task_list[1]).to have_content "task3"
            expect(task_list[2]).to have_content "task4"
          end
        end
      end
      describe '検索機能' do
        context 'タイトルであいまい検索をした場合' do
          it "検索ワードを含むタスクのみ表示される" do
            fill_in 'search[tittle]', with: 'test4'
            click_button 'commit'
            binding.irb
            expect(page).to have_content("task4")
            expect(page).not_to have_content("task3")
            expect(page).not_to have_content("task5")
          end
        end
        context 'ステータスで検索した場合' do
          it "検索したステータスに一致するタスクのみ表示される" do
            select '未着手', from: 'ステータス'
            click_button '検索'
            expect(page).to have_content("task3")
            expect(page).not_to have_content("task4")
            expect(page).not_to have_content("task5")
          end
        end
        context 'タイトルとステータスで検索した場合' do
          it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
            fill_in 'search[tittle]', with: 'test5'
            select '着手中', from: 'ステータス'
            click_button 'commit'
            expect(page).to have_content("task5")
            expect(page).not_to have_content("task3")
            expect(page).not_to have_content("task4")
          end
        end
      end
    end
  
    describe '詳細表示機能' do
      before do
        task = FactoryBot.create(:third_task) 
        FactoryBot.create(:fourth_task, user_id: task.user.id)
        FactoryBot.create(:fifth_task, user_id: task.user.id)

        visit new_session_path
        fill_in "session[email]", with:"wada@gmail.com"
        fill_in "session[password]", with:"0123456"
        click_button "login"
        visit tasks_path
      end
  
      context '任意のタスク詳細画面に遷移した場合' do
        it 'そのタスクの内容が表示される' do
          task = Task.last
          visit task_path(task.id)
          expect(page).to have_content "タスク詳細ページ"
          expect(page).to have_content task.tittle
          expect(page).to have_content task.content
        end
      end
    end

    describe '検索機能' do
      before do
        task = FactoryBot.create(:task) 
        task2 = FactoryBot.create(:fourth_task, user_id: task.user.id)
        task3 = FactoryBot.create(:fifth_task, user_id: task.user.id)
        label = FactoryBot.create(:label, user_id: task.user.id)
        labelling = FactoryBot.create(:labelling, task: task, label: label)
        visit new_session_path
        fill_in "session[email]", with: "thomas@gmail.com"
        fill_in "session[password]", with: "123456"
        click_button "commit"
        visit tasks_path
      end
  
      context 'ラベルで検索をした場合' do
        it "そのラベルの付いたタスクがすべて表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          select 'label_1', from: 'search[label_id]'
          click_button '検索'
          expect(page).to have_content "書類作成"
          expect(page).not_to have_content "メール送信"
        end
      end
    end
    
  end