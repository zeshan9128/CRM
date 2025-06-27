class AddReturnedStatusToInventoryStatuses < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      ALTER TYPE inventory_statuses ADD VALUE IF NOT EXISTS 'returned';
    SQL

    execute <<~SQL
      ALTER TYPE inventory_statuses ADD VALUE IF NOT EXISTS 'restocked';
    SQL
  end

  def down
  end
end
