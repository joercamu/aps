class Modification < ActiveRecord::Base
  include AASM
  belongs_to :order
  belongs_to :user

  aasm column: "state" do
    state :activo, initial: true
    state :aprobado
    state :rechazado

  	event :approve do
  		transitions :from => :activo, :to => :aprobado
  	end
  	event :refuse do
  		transitions :from => :activo, :to => :rechazado
  	end
  end

end
