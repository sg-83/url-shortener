class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :full
      t.string :shortened
      t.string :title
      t.integer :clicks, default: 0
      t.integer :status, index: true

      t.timestamps null: false
    end
  end
end
