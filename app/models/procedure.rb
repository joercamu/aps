class Procedure < ActiveRecord::Base
	has_many :has_procedures
	has_many :machines, through: :has_procedures 
	has_many :subprocesses
end
