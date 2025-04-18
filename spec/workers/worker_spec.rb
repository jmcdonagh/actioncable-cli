# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Worker do
  describe '#perform' do
    let(:client_id) { '12345' }
    let(:worker_channel) { class_double(WorkerChannel).as_stubbed_const }
    let(:logger) { instance_double(Logger) }
    let(:worker) { described_class.new }

    before do
      allow(Sidekiq).to receive(:logger).and_return(logger)
      allow(logger).to receive(:info)
      allow(worker_channel).to receive(:broadcast_to)
      allow(worker).to receive(:sleep)
    end

    it 'broadcasts worker_started message with total steps' do
      expect(worker_channel).to receive(:broadcast_to).with(
        "client_#{client_id}",
        type: :worker_started,
        total: 5
      )

      worker.perform(client_id)
    end

    it 'logs progress for each step' do
      expect(logger).to receive(:info).with("Step 1 for client #{client_id}")
      expect(logger).to receive(:info).with("Step 2 for client #{client_id}")
      expect(logger).to receive(:info).with("Step 3 for client #{client_id}")
      expect(logger).to receive(:info).with("Step 4 for client #{client_id}")
      expect(logger).to receive(:info).with("Step 5 for client #{client_id}")

      worker.perform(client_id)
    end

    it 'broadcasts progress for each step' do
      (1..5).each do |step|
        expect(worker_channel).to receive(:broadcast_to).with(
          "client_#{client_id}",
          type: :worker_progress,
          progress: step
        )
      end

      worker.perform(client_id)
    end

    it 'broadcasts worker_done message when complete' do
      expect(worker_channel).to receive(:broadcast_to).with(
        "client_#{client_id}",
        type: :worker_done
      )

      worker.perform(client_id)
    end
  end
end
