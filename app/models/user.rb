class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable#, :omniauthable

  include DeviseTokenAuth::Concerns::User

  mount_uploader :avatar, AvatarUploader


  #chances
  has_many :chances, :dependent => :destroy

  has_many :supports
  has_many :crowdcards

  has_many :flags

  scope :with_flag, lambda {|flag, value| joins(:flags).where("flags.name = ? and flags.value_boolean = ?", flag, value)}


  #   # the participations in user_todos:
  has_many :user_wishes, :dependent => :destroy
  has_many :wishes, through: :user_wishes

  has_many :state_users, :dependent => :destroy
  has_many :states, through: :state_users

  #validates_presence_of   :avatar
  validates_integrity_of  :avatar
  validates_processing_of :avatar
  #validates :datenschutz, inclusion: [true]

end
