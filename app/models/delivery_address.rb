class DeliveryAddress
  include Mongoid::Document

  embedded_in :user_order

  field :recipient_name, type: String
  field :phone_number,   type: String
  field :country,        type: String
  field :province,       type: String
  field :city,           type: String
  field :location_detail, type: String
end
