class CreateScheduleds < ActiveRecord::Migration
  def change
    create_table :scheduleds do |t|
      t.datetime :date
      t.string :drug
      t.string :url
      t.timestamps null: false
    end
  end
end
