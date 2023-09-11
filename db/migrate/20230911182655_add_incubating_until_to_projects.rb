class AddIncubatingUntilToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :incubating_until, :datetime, default: nil
  end
end
