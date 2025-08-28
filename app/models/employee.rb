class Employee < ApplicationRecord
  enum role: {
    warehouse: 'warehouse',
    customer_service: 'customer_service'
  }

  validates :name, presence: true
  validates :access_code, uniqueness: true
  validates :role, presence: true, inclusion: { in: roles.keys }

end
