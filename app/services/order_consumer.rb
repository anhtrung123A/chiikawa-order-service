class OrderConsumer
  EXCHANGE_NAME = "order.events"

  def self.start
    exchange = $channel.direct(EXCHANGE_NAME)

    queue = $channel.queue("order_service_queue", durable: true)

    queue.bind(exchange, routing_key: "order.created")
    queue.bind(exchange, routing_key: "order.cancelled")
    queue.bind(exchange, routing_key: "order.paid")

    puts "OrderConsumer is waiting for messages..."

    queue.subscribe(block: true) do |_delivery_info, _properties, body|
      data = JSON.parse(body)
      event = data["event"]

      case event
      when "created"
        puts "Received order created event: #{data.inspect}"
      when "paid"
        puts "Received order paid event: #{data.inspect}"
      when "cancelled"
        puts "Received order cancelled event: #{data.inspect}"
      else
        puts "Unknown event: #{event}"
      end
    end
  end
end
