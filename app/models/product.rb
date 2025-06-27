class Product < ApplicationRecord
  validates :name, presence: true
  monetize :price_cents
  has_many :inventory

  scope :with_returned_inventory, lambda {
    joins(:inventory).where(inventory: { status: 'returned' }).distinct
  }

  def in_stock_count
    inventory.on_shelf.count
  end

  def needed_inventory_count
    self.class.connection.select_value(<<~SQL)
      SELECT GREATEST(
        COALESCE(SUM(order_line_items.quantity), 0) - #{on_shelf}, 0
      )
      FROM order_line_items
        LEFT OUTER JOIN inventories
          ON order_line_items.order_id = inventories.order_id
      WHERE order_line_items.product_id = #{id}
        AND inventories.order_id IS NULL
    SQL
  end
end
