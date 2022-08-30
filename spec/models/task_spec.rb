require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(tittle: '', content: 'test', deadline_on: "2022-03-22", priority: "中", status: "未着手")
        user = User.create(name: "Iizuka", email: "iizuka@gmail.com", password:"0123456", admin: false)
        task.user_id = user.id
        task.save
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(tittle: 'Todo', content: '', deadline_on: "2022-03-22", priority: "中", status: "未着手")
        user = User.create(name: "Iizuka", email: "iizuka@gmail.com", password:"0123456", admin: false)
        task.user_id = user.id
        task.save
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.new(tittle: 'Todo', content: 'test', deadline_on: "2022-03-22", priority: "中", status: "未着手")
        user = User.create(name: "Iizuka", email: "iizuka@gmail.com", password:"0123456", admin: false)
        task.user_id = user.id
        task.save
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    # テストデータを複数作成する
    let!(:first_task) { FactoryBot.create(:first_task) }
    let!(:second_task) { FactoryBot.create(:second_task) }
    let!(:third_task) { FactoryBot.create(:third_task) }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        expect(Task.search_index(tittle: 'test1')).to include(first_task)
        expect(Task.search_index(tittle: 'test1')).not_to include(second_task)
        expect(Task.search_index(tittle: 'test1')).not_to include(third_task)
        expect(Task.search_index(tittle: 'test1').count).to eq 1
      end
    end
    #binding.irb
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_index(status: "未着手")).to include(first_task)
        expect(Task.search_index(status: "完了")).to include(second_task)
        expect(Task.search_index(status: "未着手")).to include(third_task)
        expect(Task.search_index(status: "完了").count).to eq 1
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_index(tittle: 'test1', status: "未着手")).to include(first_task)
        expect(Task.search_index(tittle: 'test1', status: "着手中")).not_to include(second_task)
        expect(Task.search_index(tittle: 'test1', status: "未着手")).not_to include(third_task)
        expect(Task.search_index(tittle: 'test1', status: "未着手").count).to eq 1
      end
    end
  end
end