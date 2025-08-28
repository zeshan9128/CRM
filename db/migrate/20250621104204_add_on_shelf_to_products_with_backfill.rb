class AddOnShelfToProductsWithBackfill < ActiveRecord::Migration[7.0]
  def up
    add_column :products, :on_shelf, :integer, default: 0, null: false
    add_index :products, :on_shelf

    # Backfill on_shelf counts from inventories
    execute <<~SQL
      UPDATE products
      SET on_shelf = COALESCE(subquery.quantity, 0)
      FROM (
        SELECT product_id, COUNT(*) AS quantity
        FROM inventories
        WHERE status = 'on_shelf'
        GROUP BY product_id
      ) AS subquery
      WHERE products.id = subquery.product_id;
    SQL
  end

  def down
    remove_column :products, :on_shelf
  end
end
