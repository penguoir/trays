class InboxItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @inbox_items = current_user.inbox_items
  end

  def new
    @inbox_item = current_user.inbox_items.build
  end

  def create
    @inbox_item = current_user.inbox_items.build(inbox_item_params)

    if @inbox_item.save
      redirect_to new_inbox_item_path, notice: "Inbox item created successfully"
    else
      render :new
    end
  end

  def show
  end

  def update
  end

  def processed
    @inbox_item = InboxItem.find(params[:id])
    @inbox_item.update!(processed: true, processed_at: Time.now)

    redirect_to inbox_items_path, notice: "Inbox item processed successfully"
  end

  def pin
    @inbox_item = InboxItem.find(params[:id])
    current_user.update!(pinned_inbox_item: @inbox_item)

    redirect_to inbox_items_path, notice: "Inbox item pinned successfully"
  end

  private

  def inbox_item_params
    params.require(:inbox_item).permit(:processed, :content)
  end
end
