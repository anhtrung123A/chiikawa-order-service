require "grpc"
require_relative "lib/order"
require "securerandom"

class OrderServer < Order::OrderService::Service
  def checkout(request, _call)
    request.items.each do |item|
      puts " - #{item.name} (#{item.quantity} x #{item.price})"
    end

    # Here you could:
    #  - Save order to MongoDB/Postgres
    #  - Check stock from ProductService
    #  - Deduct inventory
    #  - Handle payment

    Order::CheckoutResponse.new(
      order_id: SecureRandom.uuid,
      status: "success",
      message: "Order created successfully"
    )
  end
end

# Run the gRPC server
server = GRPC::RpcServer.new
server.add_http2_port("0.0.0.0:50051", :this_port_is_insecure)
server.handle(OrderServer)
puts "🟢 OrderService running on port 50051..."
server.run_till_terminated
