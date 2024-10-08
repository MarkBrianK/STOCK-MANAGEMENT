class SalesController < ApplicationController
  before_action :set_sale, only: %i[show update destroy]
  before_action :set_product, only: %i[create update]

  # GET /sales
  def index
    @sales = Sale.includes(:user, :product).all
    render json: @sales.as_json(include: [:user, :product])
  end


  # GET /sales/:id
  def show
    render json: @sale.as_json(include: :user)
  end

  # POST /sales
  def create
    @sale = Sale.new(sale_params)
    if @sale.save
      update_product_stock(@sale.product_id, -@sale.quantity) # Reduce stock level
      render json: @sale, status: :created, location: @sale
    else
      render json: @sale.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sales/:id
  def update
    old_quantity = @sale.quantity
    if @sale.update(sale_params)
      new_quantity = @sale.quantity
      quantity_change = old_quantity - new_quantity
      update_product_stock(@sale.product_id, quantity_change)
      render json: @sale
    else
      render json: @sale.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sales/:id
  def destroy
    # Increase the stock level of the product
    update_product_stock(@sale.product_id, @sale.quantity)
    @sale.destroy
    head :no_content
  end

  private

  def set_sale
    @sale = Sale.includes(:user).find(params[:id])
  end

  def set_product
    @product = Product.find(sale_params[:product_id])
  end

  def sale_params
    params.require(:sale).permit(:product_id, :user_id, :quantity, :total_price, :sale_date, :final_price, :commission)
  end

  def update_product_stock(product_id, quantity_change)
    product = Product.find(product_id)
    new_stock_level = product.stock_level - quantity_change
    if new_stock_level < 0
      render json: { error: 'Insufficient stock' }, status: :unprocessable_entity
    else
      product.update(stock_level: new_stock_level)
    end
  end
end
