class AddStatusAndReturnHandlerToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :status, :string
    add_index :orders, :status
    add_reference :orders, :return_handled_by, foreign_key: { to_table: :employees }
  end

  def data
    Order.reset_column_information

    Order.find_each do |order|
      if order.fulfilled?
        order.update_columns(status: :shipped)
      else
        order.update_columns(status: :placed)
      end
    end
  end
end
