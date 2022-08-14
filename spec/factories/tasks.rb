# 「FactoryBotを使用します」という記述
FactoryBot.define do
    # 作成するテストデータの名前を「task」とします
    # 「task」のように実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを作成されます
    factory :first_task, class: Task do
        tittle { 'test1' }
        content { 'test1' }
    end
    # 作成するテストデータの名前を「second_task」とします
    # 「second_task」のように存在しないクラス名をつける場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要がります
    factory :second_task, class: Task do
      tittle { 'test2' }
      content { 'test2' }
    end

    factory :third_task, class: Task do
        tittle { 'test3' }
        content { 'test3' }
    end
  end