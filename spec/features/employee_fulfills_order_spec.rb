require 'rails_helper'

RSpec.feature 'Employee fulfills order' do
  scenario 'successfully' do
    product = create(:product)
    employee = create(:employee, name: 'Jane Doe', access_code: '41315')
    ReceiveProduct.run(employee, product, 10)
    order = create(:order)
    create(:order_line_item, order:, product:, quantity: 5)

    visit root_path
    click_on sign_in
    attempt_code('41315')

    expect(page).to have_fulfillable_order(order)
    view_order(order)
    fulfill_order
    expect(current_path).to eq(order_path(order))
  end
end
