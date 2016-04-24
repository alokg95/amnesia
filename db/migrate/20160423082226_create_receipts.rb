class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.string :pharmacy_name
      t.datetime :date
      t.string :uuid, null: false
      t.belongs_to :receipt, index: true
      t.timestamps null: false
    end
    add_index :receipts, :uuid
  end
end
