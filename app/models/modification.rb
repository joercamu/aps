class Modification < ActiveRecord::Base
  include AASM
  belongs_to :order
  belongs_to :user
  has_many :modification_comments
  has_many :modification_attachments

  scope :unread, -> { where(viewed:false).count }
  scope :by_date, -> { order(created_at: :desc)}

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
