class AddSteamidToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :steamid_name, :string
  end
end
