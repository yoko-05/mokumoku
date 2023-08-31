# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { Faker::Lorem.word }
    content { Faker::Lorem.paragraph_by_chars(number: 100) }
    held_at { Time.current + 1.month }
    prefecture_id { [*1..47].sample }
    user
  end

  trait :woman_only_event do
    only_woman { true }
    user { FactoryBot.create(:user, :woman_user) }
  end
end
