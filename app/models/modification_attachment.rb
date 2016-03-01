class ModificationAttachment < ActiveRecord::Base
  belongs_to :modification
  belongs_to :user
  scope :images, ->{where(content_type:"image")}
end
