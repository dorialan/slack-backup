class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :text
      t.string :external_id
      t.references :user, index: true, foreign_key: true
      t.string :messageable_type
      t.integer :messageable_id

      t.timestamps null: false
    end
    add_index :messages, :external_id
    add_index :messages, :messageable_id
  end
end
