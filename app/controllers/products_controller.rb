class ProductsController < ApplicationController
  before_action :require_signin, except: :index
  before_action :set_product, only: :restock
  def index
    @products = Product.includes(:inventory).order(id: :asc)
  end

  def restock
    returned_inventories = @product.inventory.returned

    Inventory.transaction do
      returned_inventories.find_each do |inventory|
        inventory.with_lock do
          InventoryStatusChange.create!(
            inventory: inventory,
            status_from: inventory.status,
            status_to: :on_shelf,
            actor: current_user
          )
          inventory.update!(status: :on_shelf, order_id: nil)
        end
      end
    end

    redirect_to employees_path, notice: 'Returned products restocked successfully.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
