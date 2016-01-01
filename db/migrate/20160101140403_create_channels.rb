class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.string :topic
      t.string :purpose
      t.string :external_id

      t.timestamps null: false
    end
    add_index :channels, :external_id, unique: true
  end
end
