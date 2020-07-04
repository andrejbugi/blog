FactoryBot.define do
  factory :comment do
    user
    article

    body { " some comment " }
  end
end
