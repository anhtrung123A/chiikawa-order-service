class UserOrderPolicy
  attr_reader :user, :order

  def initialize(user, order)
    @user = user
    @order = order
  end
  
  def index?
    user[:role] == "admin"
  end

  def show?
    user[:id] == order.user_id || user[:role] == "admin"
  end

end
