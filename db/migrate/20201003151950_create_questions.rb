class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :user
      t.string :title
      t.string :context
      t.timestamps null: false
    end
  end
end
