class AddAddressFixedToAddresses < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :address_fixed, :boolean, default: false, null: false
  end
end
