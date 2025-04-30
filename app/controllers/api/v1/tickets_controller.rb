module Api
  module V1
    class TicketsController < ApplicationController
      before_action :set_match
      before_action :set_ticket, only: %i[ show update destroy ]

      # GET /matches/:match_id/tickets
      def index
        @tickets = @match.tickets
        render json: @tickets
      end

      # GET /matches/:match_id/tickets/1
      def show
        render json: @ticket
      end

      # POST /matches/:match_id/tickets
      def create
        @ticket = @match.tickets.new(ticket_params)

        if @ticket.save
          render json: @ticket, status: :created, location: api_v1_match_ticket_url(params[:match_id], @ticket)
        else
          render json: @ticket.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /matches/:match_id/tickets/1
      def update
        if @ticket.update(ticket_params)
          render json: @ticket
        else
          render json: @ticket.errors, status: :unprocessable_entity
        end
      end

      # DELETE /matches/:match_id/tickets/1
      def destroy
        @ticket.destroy!
      end

      private
        def set_match
          @match = Match.find(params[:match_id])
        end

        # Use callbacks to share common setup or constraints between actions.
        def set_ticket
          @ticket = @match.tickets.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def ticket_params
          params.require(:ticket).permit(:user_id, :price)
        end
    end
  end
end
