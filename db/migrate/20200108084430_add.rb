class Add < ActiveRecord::Migration[5.1]
  def change
    add_column :interviews, :date, :date
  end
end