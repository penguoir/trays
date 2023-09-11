class CreateNextActionProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :next_action_projects do |t|
      t.references :next_action, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
