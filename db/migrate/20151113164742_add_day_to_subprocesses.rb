class AddDayToSubprocesses < ActiveRecord::Migration
	#campo referente al dia que pertenece
  def change
    add_reference :subprocesses, :day, index: true, foreign_key: true
  end
end
