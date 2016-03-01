class CreateModificationAttachments < ActiveRecord::Migration
  def change
    create_table :modification_attachments do |t|
      t.string :name
      t.string :name_original
      t.string :nameid
      t.string :ext
      t.references :user, index: true, foreign_key: true
      t.references :modification, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
