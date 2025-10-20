class Api::V1::OrdersController < ApplicationController
  def show
    order = UserOrder.where(_id: params[:id]).first
    if order != nil
      authorize order
      render json: order, status: :ok
    else
      render json: { error: "order not found" }, status: :not_found
    end
  end

  def index
    orders = UserOrder.where(user_id: current_user[:id])
    render json: { orders: orders }, status: :ok
  end

end