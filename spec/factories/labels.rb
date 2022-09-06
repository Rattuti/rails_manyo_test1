FactoryBot.define do
  factory :label do
    name { "label_1" }
    association :user, factory: :third_user
  end

  factory :second_label, class: Label do
    name { "label_2" }
    association :user, factory: :third_user
  end

  factory :third_label, class: Label do
    name { "label_3" }
    association :user, factory: :third_user
  end
end