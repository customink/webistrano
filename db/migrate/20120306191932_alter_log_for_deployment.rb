class AlterLogForDeployment < ActiveRecord::Migration
  def self.up
    change_column :deployments, :log, :text, :limit => 4294967295
  end

  def self.down
  end
end