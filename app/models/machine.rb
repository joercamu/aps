class Machine < ActiveRecord::Base
	has_many :has_procedures
	has_many :procedures, through: :has_procedures
	has_many :standards
end
