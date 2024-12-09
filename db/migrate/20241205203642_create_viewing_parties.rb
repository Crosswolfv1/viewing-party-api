# frozen_string_literal: true

class CreateViewingParties < ActiveRecord::Migration[7.1]
  def change
    create_table :viewing_parties do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
