class AddPinnedInboxItemToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :pinned_inbox_item,
      foreign_key: { to_table: :inbox_items }, null: true, default: nil
  end
end
