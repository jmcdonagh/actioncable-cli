# frozen_string_literal: true

# vim:filetype=ruby

require 'thor'
require 'securerandom'
require 'net/http'
require 'async'
require 'async/io/stream'
require 'async/http/endpoint'
require 'async/websocket/client'
require 'ruby-progressbar'

# :reek:DataClump
# Basic Worker to run things in background.
class Worker < Thor
  include Thor::Actions

  attr_reader(
    :client_id
  )

  desc 'start', 'Start a worker process'

  def start
    self.client_id = SecureRandom.uuid

    Async do
      Async::WebSocket::Client.connect(endpoint) { |conn| connloop(conn) }
    end
  end

  private

  attr_accessor(
    :bar,
  )

  attr_writer(
    :client_id,
  )

  def connloop(conn)
    while (message = conn.read)
      begin
        message = JSON.parse(message.buffer, symbolize_names: true)
      rescue StandardError => e
        shell.say 'could not parse JSON message', :red
        shell.say e.message, :red
        next
      end

      on_receive(conn, message)
    end
  end

  def endpoint = Async::HTTP::Endpoint.parse(url)
  def url = "ws://localhost:3000/cable?client_id=#{client_id}"

  # :reek:DataClump
  def on_receive(conn, message)
    if message[:type]
      handle_conn_message(conn, message)
    else
      handle_channel_message(conn, message)
    end
  end

  # :reek:DataClump
  def handle_conn_message(conn, message)
    type = message[:type]
    case type
    when 'welcome'
      on_connected(conn)
    when 'confirm_subscription'
      on_subscribed
    end
  end

  # :reek:DataClump
  def handle_channel_message(conn, message)
    message = message[:message]
    type = message[:type]
    case type
    when 'worker_started'
      total = message[:total]
      self.bar = ProgressBar.create(
        title: 'Worker Progress',
        total: total,
        format: '%t %B %c/%C %P%%',
      )
    when 'worker_progress'
      bar.increment
    when 'worker_done'
      puts 'DONE'
      conn.close
    end
  end

  # :reek:UtilityFunction
  def on_connected(conn)
    content = {
      command: 'subscribe',
      identifier: {
        channel: 'WorkerChannel',
      }.to_json,
    }.to_json

    conn.write(content)
    conn.flush
  end

  def on_subscribed
    Net::HTTP.start('localhost', 3000) do |http|
      http.get("/workers/start?client_id=#{client_id}")
    end
  end
end
