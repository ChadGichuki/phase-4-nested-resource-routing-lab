class ItemsController < ApplicationController

  def index
    if params[:user_id]
      user = User.find_by!(id:params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  rescue ActiveRecord::RecordNotFound => e
    render json: {errors: e}, status: :not_found
  end

  def show
    @item = Item.find(params[:id])
    render json: @item, include: :user
  rescue ActiveRecord::RecordNotFound => e
    render json: {errors: e}, status: :not_found
  end

  def create
    user = User.find(params[:user_id])
    item = Item.create(item_params)
    user.items << item
    render json: item, include: :user, status: :created
  end

  private
  
  def item_params
    params.permit(:name, :description, :price, :user_id, :created_at, :updated_at)
  end

end
