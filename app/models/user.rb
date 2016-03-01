class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :order_comments
  has_many :modification_comments
  has_many :modification_attachments
  has_many :leftovers
  has_many :orders
  has_many :modifications
  def name_email
  	self.email.split('@').first
  end
  def avatar_url
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?d=retro"
  end
end
