# spec/models/employee_spec.rb
require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validations' do
    it 'is valid with a warehouse role' do
      employee = Employee.new(name: 'Zeshan', role: 'warehouse')
      expect(employee).to be_valid
    end

    it 'is valid with a customer_service role' do
      employee = Employee.new(name: 'Sara', role: 'customer_service')
      expect(employee).to be_valid
    end

    it 'is invalid with a blank role' do
      employee = Employee.new(name: 'Invalid', role: nil)
      expect(employee).to be_invalid
      expect(employee.errors[:role]).to include("can't be blank")
    end

    it 'raises ArgumentError when assigning an unknown role' do
      expect {
        Employee.new(name: 'Invalid', role: 'admin')
      }.to raise_error(ArgumentError, "'admin' is not a valid role")
    end
  end

  describe 'enum methods' do
    let(:employee) { Employee.create!(name: 'Zeeshan', role: 'warehouse', access_code: 999 ) }

    it 'returns true for warehouse? if role is warehouse' do
      expect(employee.warehouse?).to be true
    end

    it 'returns false for customer_service? if role is warehouse' do
      expect(employee.customer_service?).to be false
    end
  end
end
