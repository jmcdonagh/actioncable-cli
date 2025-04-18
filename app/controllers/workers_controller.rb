# frozen_string_literal: true

# Basically the only endpoint for the demo.
class WorkersController < ApplicationController
  def start
    Worker.perform_async(params[:client_id])
    head(:ok)
  end
end
