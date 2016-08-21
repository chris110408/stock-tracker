class UserStocksController < ApplicationController
  before_action :set_user_stock, only: [:show, :edit, :update]

  # GET /user_stocks
  def index
    @user_stocks = UserStock.all
  end

  # GET /user_stocks/1
  def show
  end

  # GET /user_stocks/new
  def new
    @user_stock = UserStock.new
  end

  # POST /user_stocks
  def create
    if params[:stock_id].present?
      @user_stock = UserStock.new(stock_id:params[:stock_id],user:current_user)
    else
      stock = Stock.find_by_ticker(params[:stock_ticker])
      if stock
        @user_stock= UserStock.new(user:current_user,stock: stock)
      else
        stock = Stock.new_from_lookup(params[:stock_ticker])
        if stock.save
          @user_stock = UserStock.new(user:current_user,stock:stock)
        else
          @user_stock = nil
          flash[:error] = "Stock is not available"
        end
      end
    end



    if @user_stock.save
      flash[:success]= "Stock #{@user_stock.stock.ticker} has been added."
      redirect_to my_portfolio_path
    else
      flash[:error]= 'error'
      render "new"
    end
  end

  # GET /user_stocks/1/edit
  def edit
  end



  PATCH/PUT /user_stocks/1
  def update
    if @user_stock.update(user_stock_params)
      redirect_to @user_stock, notice: 'User stock was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user_stocks/1
  def destroy
    @user_stock = UserStock.where(:stock_id => params[:id],:user_id => current_user)
    @user_stock.destroy_all
    redirect_to my_portfolio_path, notice: 'User stock was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_stock

      @user_stock = UserStock.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_stock_params
      params.require(:user_stock).permit(:user_id, :stock_id)
    end
end
