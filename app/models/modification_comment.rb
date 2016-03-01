class ModificationComment < ActiveRecord::Base
  belongs_to :modification
  belongs_to :user
end
