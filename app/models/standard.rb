class Standard < ActiveRecord::Base
  belongs_to :machine
  has_many :subprocesses
end
