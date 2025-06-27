require 'rails_helper'

RSpec.describe OrderReturnService, type: :service do
  describe '.call' do
    let(:employee) { create(:employee) }
    let(:order) { create(:order) }
    let!(:inventory_1) { create(:inventory, order:, status: 'shipped') }
    let!(:inventory_2) { create(:inventory, order:, status: 'shipped') }

    context 'when the order is fulfilled' do
      it 'changes order status to returned' do
        OrderReturnService.call(order:, employee:)

        expect(order.reload.status).to eq('returned')
        expect(order.return_handled_by).to eq(employee)
      end

      it 'updates all inventory items to returned' do
        OrderReturnService.call(order:, employee:)

        expect(order.inventories.pluck(:status)).to all(eq('returned'))
      end

      it 'creates inventory status changes for each inventory' do
        expect {
          OrderReturnService.call(order:, employee:)
        }.to change(InventoryStatusChange, :count).by(2)

        changes = InventoryStatusChange.where(inventory_id: [inventory_1.id, inventory_2.id])
        expect(changes.map(&:status_to)).to all(eq('returned'))
        expect(changes.map(&:actor)).to all(eq(employee))
      end
    end

  end
end
