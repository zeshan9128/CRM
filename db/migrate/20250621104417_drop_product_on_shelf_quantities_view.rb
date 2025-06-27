class DropProductOnShelfQuantitiesView < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      DROP VIEW IF EXISTS product_on_shelf_quantities;
    SQL
  end

  def down
    execute <<~SQL
      CREATE VIEW product_on_shelf_quantities AS
      SELECT i.product_id, COUNT(i.product_id) AS quantity
      FROM inventories AS i
      WHERE i.status = 'on_shelf'
      GROUP BY i.product_id
      ORDER BY i.product_id;
    SQL
  end
end
