class UserOrder
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: "orders"

  field :user_id, type: Integer
  field :status, type: String, default: "pending"
  field :promotion_code, type: String, default: nil
  field :confirmed_at, type: Date, default: nil
  field :canceled_at, type: Date, default: nil
  field :payment_id, type: String, default: nil
  field :paid_at, type: Date, default: nil
  embeds_many :order_items, cascade_callbacks: true
  embeds_one :payment, cascade_callbacks: false
  embeds_one :delivery_address, cascade_callbacks: true

  accepts_nested_attributes_for :delivery_address
  index({ user_id: 1 })

  accepts_nested_attributes_for :order_items, allow_destroy: true

  validates :user_id, presence: true

  def total_price
    order_items.sum { |item| item.price.to_f * item.quantity.to_i }
  end
  STATUSES = %w[pending canceled confirmed paid]

  def pending!
    update(status: "pending")
  end

  def paid!
    update(status: "paid")
  end

  def canceled!
    update(status: "canceled")
  end

  def confirmed!
    update(status: "confirmed")
  end

  def pending?
    status == "pending"
  end

  def canceled?
    status == "canceled"
  end

  def confirmed?
    status == "confirmed"
  end

  def paid?
    status == "paid"
  end
end
