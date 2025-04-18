# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection do
  let(:client_id) { '12345' }

  it 'successfully connects with client_id' do
    connect params: { client_id: client_id }
    expect(connection.client_id).to eq client_id
  end
end
