class AddressesController < ApplicationController
  before_action :set_address, only: [:edit, :update]

  def edit
  end

  def update
    if params[:mark_fixed].present?
      mark_address_as_fixed
    elsif @address.update(address_params)
      redirect_to employees_path, notice: 'Address updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def mark_address_as_fixed
    if @address.update(address_fixed: true)
      redirect_to employees_path, notice: 'Address marked as fixed.'
    else
      redirect_to edit_address_path(@address), alert: 'Failed to mark address as fixed.'
    end
  end

  def address_params
    params.require(:address).permit(
      :recipient, :street_1, :street_2, :city, :state, :zip, :address_fixed
    )
  end

  def set_address
    @address = Address.find(params[:id])
  end
end
