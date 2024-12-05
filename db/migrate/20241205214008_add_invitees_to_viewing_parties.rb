class AddInviteesToViewingParties < ActiveRecord::Migration[7.1]
  def change
    add_column :viewing_parties, :invitees, :integer, array: true, default: [], null: false
  end
end
