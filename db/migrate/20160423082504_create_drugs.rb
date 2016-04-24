class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.belongs_to :receipt, index: true
      t.string :name
      t.string :vendor
      t.decimal :price
      t.timestamps null: false
    end
  end
end
