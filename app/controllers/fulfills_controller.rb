class FulfillsController < ApplicationController
  before_action :require_signin
  before_action :set_order, only: %i[create return_order restock_order]

  def create
    FindFulfillableOrder.fulfill_order(current_user, params[:order_id])

    redirect_to @order, alert: 'Order fulfilled successfully'
  end

  def return_order
    OrderReturnService.call(order: @order, employee: current_user)
    redirect_to @order, alert: 'Order marked as returned.'
  rescue StandardError => e
    redirect_to @order, alert: "Return failed: #{e.message}"
  end

  def restock_order
    OrderRestockService.call(order: @order, employee: current_user)
    redirect_to @order, alert: 'Order inventory restocked.'
  rescue StandardError => e
    redirect_to @order, alert: "Return failed: #{e.message}"
  end

  def set_order
    @order = Order.find(params[:order_id])
  end
end
