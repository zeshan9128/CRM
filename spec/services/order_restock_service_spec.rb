require 'rails_helper'

RSpec.describe OrderRestockService, type: :service do
  describe '.call' do
    let(:employee) { create(:employee) }
    let(:order) { create(:order, status: 'returned') }
    let!(:inventory1) { create(:inventory, order: order, status: 'returned') }
    let!(:inventory2) { create(:inventory, order: order, status: 'returned') }

    context 'when the order is returned' do
      it 'changes order status to restocked' do
        OrderRestockService.call(order: order, employee: employee)

        expect(order.reload.status).to eq('restocked')
      end

      it 'updates all inventory statuses to on_shelf and clears their orders' do
        described_class.call(order: order, employee: employee)

        order.inventories.each do |inv|
          expect(inv.reload.status).to eq('on_shelf')
          expect(inv.order).to be_nil
        end
      end

      it 'creates inventory status changes' do
        expect {
          described_class.call(order: order, employee: employee)
        }.to change(InventoryStatusChange, :count).by(2)

        status_changes = InventoryStatusChange.where(inventory: [inventory1, inventory2])
        expect(status_changes.map(&:status_to)).to all(eq('restocked'))
        expect(status_changes.map(&:actor)).to all(eq(employee))
      end
    end

  end
end
