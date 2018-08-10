class HomepageController < ApplicationController
  def index
    @messages = Message.all.order(:created_at).reverse_order.limit(5)
  end
end
