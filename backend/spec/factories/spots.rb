FactoryBot.define do
  factory :spot do
    association :region
    sequence(:name) { |n| "テストスポット#{n}" }
    category      { "nature" }
    cost          { 1000 }
    duration_min  { 60 }
    indoor_outdoor { "either" }
    description   { "テスト用スポットの説明文" }

    trait :outdoor do
      indoor_outdoor { "outdoor" }
    end

    trait :indoor do
      indoor_outdoor { "indoor" }
    end

    trait :nature do
      category { "nature" }
      indoor_outdoor { "outdoor" }
    end

    trait :gourmet do
      category { "gourmet" }
      indoor_outdoor { "either" }
    end

    trait :historical do
      category { "historical" }
      indoor_outdoor { "indoor" }
    end

    trait :shopping do
      category { "shopping" }
      indoor_outdoor { "either" }
    end

    trait :activity do
      category { "activity" }
      indoor_outdoor { "indoor" }
    end

    trait :relax do
      category { "relax" }
      indoor_outdoor { "indoor" }
    end

    trait :free do
      cost { 0 }
    end
  end
end
