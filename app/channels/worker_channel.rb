# frozen_string_literal: true

# If you want to add auth you would add it here.
class WorkerChannel < ApplicationCable::Channel
  def subscribed = stream_for "client_#{client_id}"
  def unsubscribed = stop_all_streams
end
