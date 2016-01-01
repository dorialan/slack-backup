class CreateMessageables < ActiveRecord::Migration
  def change
    create_table :messageables do |t|
      t.string :name
      t.string :topic
      t.string :purpose
      t.string :external_id
      t.string :type

      t.timestamps null: false
    end
    add_index :messageables, [:type, :external_id], unique: true
  end
end
