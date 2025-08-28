class Inventory < ApplicationRecord
  enum status: InventoryStatusChange::STATUSES
  has_many :inventory_status_changes, dependent: :destroy
  belongs_to :product, counter_cache: :on_shelf
  belongs_to :order, required: false

  validates :product, presence: true

  after_update :adjust_on_shelf_counter, if: :saved_change_to_status?

  private

  def adjust_on_shelf_counter
    if status_previously_was == 'on_shelf' && status == 'shipped'
      product.decrement!(:on_shelf)
    elsif status_previously_was == 'returned' && status == 'on_shelf'
      product.increment!(:on_shelf)
    end
  end
end
