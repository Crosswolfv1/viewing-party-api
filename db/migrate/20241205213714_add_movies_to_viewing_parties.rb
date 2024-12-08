class AddMoviesToViewingParties < ActiveRecord::Migration[7.1]
  def change
    add_column :viewing_parties, :movie_id, :bigint, null: false
    add_column :viewing_parties, :movie_title, :string, null: false
  end
end
