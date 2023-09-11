class AddWaitingForToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :waiting_for, :string
  end
end
