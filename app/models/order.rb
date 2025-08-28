class Order < ApplicationRecord
  belongs_to :ships_to, class_name: 'Address'
  has_many :line_items, class_name: 'OrderLineItem'
  has_many :inventories
  belongs_to :return_handled_by, class_name: 'Employee', optional: true

  scope :recent, -> { order(created_at: :desc) }
  scope :fulfilled, -> { joins(:inventories).group('orders.id') }
  scope :not_fulfilled, -> { left_joins(:inventories).where(inventories: { order_id: nil }) }
  scope :fulfillable, lambda {
    not_fulfilled
      .joins(:line_items)
      .joins(<<~SQL)
      INNER JOIN products
        ON products.id = order_line_items.product_id
    SQL
      .where('order_line_items.quantity <= products.on_shelf')
      .group('orders.id')
      .having('COUNT(DISTINCT order_line_items.product_id) = COUNT(DISTINCT products.id)')
      .order(:created_at, :id)
  }
  enum status: { placed: 'placed', shipped: 'shipped', returned: 'returned', restocked: 'restocked' }

  def cost
    line_items.inject(Money.zero) do |acc, li|
      acc + li.cost
    end
  end

  def fulfilled?
    inventories.any?
  end

  # As per my understanding, this function compares the product quantity in each line item individually
  # against the available product count. If an order contains multiple line items with the same product ID,
  # this method will fail to compute the correct total quantity required.

  # Solution: We can ensure that line items have unique product IDs per order, or alternatively,
  # aggregate the quantities of the same product ID before performing the comparison.

  def fulfillable?
    line_items.all?(&:fulfillable?)
  end

  def returned?
    status == 'returned'
  end

  def restocked?
    status == 'restocked'
  end
end
