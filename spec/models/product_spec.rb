require 'rails_helper'

RSpec.describe Product do
  describe '#needed_inventory_count' do
    let(:product) { create(:product) }
    let(:other_product) { create(:product) }
    let(:employee) { create(:employee) }
    let(:order) { create(:order) }
    let(:other_order) { create(:order) }
    let(:quantity) { 10 }

    before do
      ReceiveProduct.run(employee, product, quantity)
      ReceiveProduct.run(employee, other_product, quantity)
    end

    it 'returns 0 if there are more units in the inventory than sold' do
      create(:order_line_item, order:, product:, quantity: quantity - 1)

      expect(product.needed_inventory_count).to eq(0)
      expect(other_product.needed_inventory_count).to eq(0)
    end

    it 'returns 0 if there are exactly the same units in the inventory than sold' do
      create(:order_line_item, order:, product:, quantity:)

      expect(product.needed_inventory_count).to eq(0)
      expect(other_product.needed_inventory_count).to eq(0)
    end

    it 'returns the deficit in the inventory' do
      create(:order_line_item, order:, product:, quantity: quantity + 1)

      expect(product.needed_inventory_count).to eq(1)
      expect(other_product.needed_inventory_count).to eq(0)
    end

    it 'takes into account shipped units' do
      create(:order_line_item, order:, product:, quantity:)
      FindFulfillableOrder.fulfill_order(employee, order.id)

      create(:order_line_item, order: other_order, product:, quantity: 1)
      create(:order_line_item, order: other_order, product: other_product, quantity: quantity + 1)
      product.reload
      expect(product.needed_inventory_count).to eq(1)
      expect(other_product.needed_inventory_count).to eq(1)
    end

    it 'increments product on shelf when inventory is created' do
      expect{
        product.inventory.create(status: 'on_shelf')
      }.to change{ product.reload.on_shelf }.by(1)
    end

    it 'decrements product on shelf when inventory is destroyed' do
      expect{
        product.inventory.first.destroy
      }.to change { product.reload.on_shelf }.by(-1)
    end
  end
end
