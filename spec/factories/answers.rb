FactoryBot.define do
  sequence :body_text do |n|
    "Text#{n}"
  end

  factory :answer do
    body { generate(:body_text) }
    question
    author factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
