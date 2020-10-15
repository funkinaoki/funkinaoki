class CreateSenmonkas < ActiveRecord::Migration[5.2]
  def change
    create_table :senmonkas do |t|
      t.string :name
      t.string :password_digest
      t.string :career
      t.boolean :acceptance
      t.boolean :reject
      t.timestamps null: false
    end
  end
end
