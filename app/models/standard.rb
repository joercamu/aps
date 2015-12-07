class Standard < ActiveRecord::Base
  belongs_to :machine
  has_many :subprocesses
  validates :index, :machine_id, :um, :per_hour, presence: true
end
