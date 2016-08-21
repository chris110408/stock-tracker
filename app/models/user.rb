class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_stocks
  has_many :stocks,through: :user_stocks

  def full_name
    return "#{first_name} #{last_name}".strip if(first_name || last_name)
    "anonymous"
  end

  def can_add_stock?(ticker_symol)
    under_stock_limit? && !stock_already_added?(ticker_symol)
  end

  def under_stock_limit?
    (user_stocks.count < 10)
  end

  def stock_already_added?(ticker_symol)
    stock = Stock.find_by_ticker(ticker_symol)
    return false unless stock
    user_stocks.where(stock_id: stock.id).exists?
  end
end
