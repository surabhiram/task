class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :address
      t.integer :num_of_ppl

      t.timestamps
    end
  end
end
