FactoryBot.define do
  factory :order do
    ships_to factory: :address
    status { 'placed'}
  end

  factory :order_line_item do
    product
    order
    quantity { 1 }
  end

  factory :address do
    recipient { 'Full name' }
    street_1 { '123 Main St' }
    city { 'New York City' }
    state { 'NY' }
    zip { '10001' }
    address_fixed { false }
  end

  factory :employee do
    sequence(:name) { |n| "Employee ##{n}" }
    sequence(:access_code) { |n| format('%05d', n) }
  end

  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price factory: :amount
  end

  factory :amount, class: Money do
    skip_create
    initialize_with { new(cents, currency) }

    transient do
      cents { 0 }
      currency { 'USD' }
    end

    trait :small do
      cents { 499 }
    end

    trait :medium do
      cents { 1299 }
    end

    trait :large do
      cents { 3299 }
    end
  end

  factory :inventory do
    status { 'on_shelf' }
    association :order
    association :product

    trait :on_shelf do
      status { 'on_shelf' }
    end
    trait :shipped do
      status { 'shipped' }
    end

    trait :returned do
      status { 'returned' }
    end
  end

end
