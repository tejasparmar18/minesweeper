# frozen_string_literal: true

FactoryBot.define do
  factory :board do
    name { Faker::Game.title[0..19] }
    email { Faker::Internet.email }
    width { Faker::Number.between(from: 2, to: 10) }
    height { Faker::Number.between(from: 2, to: 10) }
    mines_count { Faker::Number.between(from: 1, to: width * height - 1) }
  end
end
