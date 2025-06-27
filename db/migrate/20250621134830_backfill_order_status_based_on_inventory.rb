class BackfillOrderStatusBasedOnInventory < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    Order.reset_column_information

    Order.find_each do |order|
      status = order.inventories.exists? ? 'shipped' : 'placed'
      order.update_columns(status:)
    end
  end

  def down
  end
end
