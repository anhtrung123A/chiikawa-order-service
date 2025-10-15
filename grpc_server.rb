require_relative "config/environment"
require "grpc"
require_relative "lib/order"
require_relative "app/models/user_order"
require_relative "app/models/order_item"
class OrderServer < Order::OrderService::Service
  def checkout(request, _call)
    order = UserOrder.new
    order_items = []
    order.user_id = request.user_id
    order.promotion_code = request.promotion_code
    request.items.each do |item|
      order_items << OrderItem.new(product_id: item.product_id, name: item.name,
      quantity: item.quantity, price: item.price, image: item.image)
    end
    order.order_items = order_items
    order.save
    Order::CheckoutResponse.new(
      order_id: order.id.to_s,
      status: "success",
      message: "Order created successfully"
    )
  end

  def get_order_detail(request, _call)
    order = UserOrder.where(id: request.order_id).first

    if order.nil?
      raise GRPC::BadStatus.new_status_exception(
        GRPC::Core::StatusCodes::NOT_FOUND,
        "Order not found"
      )
    end

    if order.user_id != request.user_id
      raise GRPC::BadStatus.new_status_exception(
        GRPC::Core::StatusCodes::UNAUTHENTICATED,
        "Unauthorized to access this order"
      )
    end

    items = order.order_items.map do |item|
      Order::CartItem.new(
        product_id: item.product_id,
        name: item.name,
        image: item.image,
        price: item.price,
        quantity: item.quantity
      )
    end

    Order::GetOrderDetailResponse.new(
      order_id: order.id.to_s,
      promotion_code: order.promotion_code,
      user_id: order.user_id,
      items: items,
      status: order.status,
      created_at: order.created_at.to_s
    )
  end

end

# Run the gRPC server
server = GRPC::RpcServer.new
server.add_http2_port("0.0.0.0:50051", :this_port_is_insecure)
server.handle(OrderServer)
puts "OrderService running on port 50051..."
server.run_till_terminated
