class RenameItemEnableToStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :enable, :status
  end
end
