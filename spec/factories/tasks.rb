# 「FactoryBotを使用します」という記述
FactoryBot.define do
    # 作成するテストデータの名前を「task」とします
    # 「task」のように実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを作成されます
    factory  :first_task, class: Task do
        tittle { 'test1' }
        content { 'task1' }
        deadline_on { '2025-02-18' }
        priority { '中' }
        status { '未着手' }
        association :user
    end
    # 作成するテストデータの名前を「second_task」とします
    # 「second_task」のように存在しないクラス名をつける場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要がります
    factory :second_task, class: Task do
        tittle { 'test2' }
        content { 'task2' }
        deadline_on { '2025-02-17' }
        priority { '高' }
        status {'未着手'}
        association :user, factory: :second_user
    end
  
    factory :third_task, class: Task do
      tittle { 'test3' }
      content { 'task3' }
      deadline_on { '2025-02-16' }
      priority { '低' }
      status { '完了' }
      association :user, factory: :third_user
    end
  
    factory :fourth_task, class: Task do
      tittle { 'test4' }
      content { 'task4' }
      deadline_on { '2025-02-19' }
      priority { '低' }
      status { '完了' }
      association :user, factory: :third_user
    end
  
    factory :fifth_task, class: Task do
      tittle { 'test5' }
      content { 'task5' }
      deadline_on { '2025-02-20' }
      priority { '高' }
      status { '着手中' }
      association :user, factory: :third_user
    end
  end