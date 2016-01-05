class Machine < ActiveRecord::Base
	has_many :has_procedures
	has_many :procedures, through: :has_procedures
	has_many :standards
	has_many :days
	has_many :subprocesses, through: :standards
end
