class CreateInboxItems < ActiveRecord::Migration[7.0]
  def change
    create_table :inbox_items do |t|
      t.boolean :processed, default: false, null: false
      t.datetime :processed_at
      t.references :user

      t.timestamps
    end
  end
end
