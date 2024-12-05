class CreateJoinTableViewingPartiesUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :viewing_parties, :users do |t|
      # t.index [:viewing_party_id, :user_id]
      # t.index [:user_id, :viewing_party_id]
    end
  end
end
