class CreateNextActions < ActiveRecord::Migration[7.0]
  def change
    create_table :next_actions do |t|
      t.string :name, null: false
      t.datetime :completed_at, null: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
