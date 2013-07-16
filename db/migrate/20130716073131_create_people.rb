class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.string :mob
      t.integer :house_id

      t.timestamps
    end
  end
end
