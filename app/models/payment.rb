class Payment
  include Mongoid::Document

  # Fields
  field :paid_at, type: Integer
  field :amount_subtotal, type: Float
  field :amount_total, type: Float
  field :promotion_code, type: String, default: nil
  field :payment_method, type: Array, default: nil
  # Relations
  embedded_in :user_order

end
