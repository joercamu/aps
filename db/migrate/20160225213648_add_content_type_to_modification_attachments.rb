class AddContentTypeToModificationAttachments < ActiveRecord::Migration
  def change
    add_column :modification_attachments, :content_type, :string
  end
end
