FactoryBot.define do
  factory :user do
    name { "Iizuka" }
    email { "iizuka@gmail.com" }
    password { "0123456" }
    admin { false }
  end

  factory :second_user, class: User do
    name { "Yamada" }
    email { "yamada@gmail.com" }
    password { "0123456" }
    admin { false }
  end

  factory :third_user, class: User do
    name { "Wada" }
    email { "wada@gmail.com" }
    password { "0123456" }
    admin { false }
  end

  factory :fourth_user, class: User do
    name { "Akira" }
    email { "akira@gmail.com" }
    password { "0123456" }
    admin { true }
  end
end