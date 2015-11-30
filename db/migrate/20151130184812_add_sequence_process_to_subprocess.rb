class AddSequenceProcessToSubprocess < ActiveRecord::Migration
  def change
    add_column :subprocesses, :sequence_process, :integer, default:0
  end
end
