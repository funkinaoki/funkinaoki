class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.references :list
      t.timestamps null: false
      # 必ず日付入れてね
    end
  end
end