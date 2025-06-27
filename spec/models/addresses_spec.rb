require 'rails_helper'

RSpec.describe 'Addresses', type: :request do
  let(:address) { create(:address) }
  let!(:returned_order) { create(:order, status: 'returned', ships_to: address) }


  describe 'PUT /addresses/:id?mark_fixed=true' do
    it 'marks the address as fixed' do
      put address_path(address), params: { mark_fixed: true }
      expect(response).to redirect_to(employees_path)
      expect(address.reload.address_fixed).to be true
    end
  end

  describe 'PUT /addresses/:id' do
    it 'updates the address fields' do
      put address_path(address), params: {
        address: {
          recipient: 'Jane Doe',
          street_1: '456 New St',
          city: 'Karachi',
          state: 'Sindh',
          zip: '74000'
        }
      }

      address.reload
      expect(address.recipient).to eq('Jane Doe')
      expect(address.city).to eq('Karachi')
    end

    it 'renders edit on validation error' do
      put address_path(address), params: {
        address: { recipient: '' } # invalid
      }

      expect(response.body).to include('form') # crude check
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
