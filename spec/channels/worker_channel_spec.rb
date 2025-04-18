# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkerChannel do
  let(:client_id) { '12345' }

  before do
    stub_connection client_id: client_id
  end

  describe '#subscribed' do
    it 'subscribes to the correct client stream' do
      subscribe
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for("worker:client_#{client_id}")
    end
  end

  describe '#unsubscribed' do
    it 'has no streams after unsubscribing' do
      subscribe
      unsubscribe
      expect(subscription.streams).to be_empty
    end
  end
end
