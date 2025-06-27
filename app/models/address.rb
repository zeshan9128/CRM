class Address < ApplicationRecord
  has_many :orders, foreign_key: :ships_to_id

  scope :with_returned_orders, -> {
    joins(:orders).where(orders: { status: 'returned' }).where(address_fixed: false).distinct
  }

  validates :recipient, :street_1, :city, :state, :zip, presence: true
end
