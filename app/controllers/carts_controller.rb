class CartsController < ApplicationController
  before_action :load_cart
  after_action :write_cart, only: [:add_item, :remove_item, :update_item]

  def load_cart
    if cookies[:cart]
      @cart = JSON.parse(cookies[:cart])
    else
      @cart = {}
    end
  end

  def write_cart
    cookies[:cart] = JSON.generate(@cart)
  end

  def show
    @items = []
    @totalprice = 0

    @cart.each do |item_id,quantity|
      item = Item.find_by(id: item_id)
      item.define_singleton_method(:quantity) do
        quantity
      end
      @items << item

      @totalprice += item.price.to_f * item.quantity.to_i
      
    end
  end

  def add_item
    if @cart[params[:id]]
      quantity = params[:quantity].to_i
      quantityOld = @cart[params[:id]].to_i
      @cart[params[:id]] = quantityOld + quantity
    else
      @cart[params[:id]] = params[:quantity]
    end
  end

  def update_item
    if @cart[params[:id]]
      @cart[params[:id]] = params[:quantity]
    end
    redirect_to cart_path
  end

  def remove_item
    @cart.delete params[:id]
    redirect_to cart_path
  end

end
