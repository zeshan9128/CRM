class OrderRestockService
  def self.call(order:, employee:)
    raise 'Only returned orders can be restocked' unless order.returned?

    new(order, employee).process
  end

  def initialize(order, employee)
    @order = order
    @employee = employee
  end

  def process
    Order.transaction do
      Inventory.transaction do
        @order.inventories.each do |inventory|
          restock_inventory(inventory)
        end
      end

      @order.update!(status: 'restocked')
    end
  end

  private

  def restock_inventory(inventory)
    inventory.with_lock do
      InventoryStatusChange.create!(
        inventory:,
        status_from: inventory.status,
        status_to: :restocked,
        actor: @employee
      )

      inventory.update!(status: 'on_shelf', order: nil)
    end
  end
end

