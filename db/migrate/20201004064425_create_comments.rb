class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :senmonka
      t.references :question
      t.string :comment_context
      t.timestamps null: false
    end

  end
end
