class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # Returns the active order for this session
  def current_order
    @current_order ||= begin
      if has_order?
        @current_order
      else
        order = Shopr::Order.create(ip_address: request.ip, billing_country: Shopr::Country.where(name: 'United Kingdom').first)
        session[:order_id] = order.id
        order
      end
    end
  end

  # Has an active order?
  def has_order?
    session[:order_id] && @current_order = Shopr::Order.includes(order_items: :ordered_item).find_by(id: session[:order_id])
  end

  helper_method :current_order, :has_order?
end
