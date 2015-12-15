class CreateModifications < ActiveRecord::Migration
  def change
    create_table :modifications do |t|
      t.references :order, index: true, foreign_key: true
      t.string :priority
      t.string :type
      t.text :body
      t.references :user, index: true, foreign_key: true
      t.string :state, default:"activo"

      t.timestamps null: false
    end
  end
end
