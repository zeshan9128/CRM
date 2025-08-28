class OrderReturnService
  def self.call(order:, employee:)
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
          return_inventory(inventory)
        end
      end

      @order.update!(status: 'returned', return_handled_by: @employee)
    end
  end

  private

  def return_inventory(inventory)
    inventory.with_lock do
      InventoryStatusChange.create!(
        inventory:,
        status_from: inventory.status,
        status_to: :returned,
        actor: @employee
      )

      inventory.update!(status: 'returned')
    end
  end
end
