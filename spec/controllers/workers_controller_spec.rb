# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkersController do
  describe '#start' do
    let(:client_id) { '12345' }
    let(:worker_class) { class_double(Worker).as_stubbed_const }

    before do
      allow(worker_class).to receive(:perform_async)
    end

    it 'enqueues a Worker job with the client_id' do
      expect(worker_class).to receive(:perform_async).with(client_id)

      process :start, method: :post, params: { client_id: client_id }
    end

    it 'returns an HTTP 200 status' do
      process :start, method: :post, params: { client_id: client_id }

      expect(response).to have_http_status(:ok)
    end
  end
end
