class EmployeesController < ApplicationController
  before_action :require_signin

  def index
    @fulfillable_orders = Order.fulfillable.limit(10)
    @recent_orders = Order.recent.limit(10)
    @products = Product.all
    @products_with_returns = Product.with_returned_inventory
    @addresses = Address.with_returned_orders.includes(:orders)
  end
end
