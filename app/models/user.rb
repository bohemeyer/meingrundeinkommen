class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  #chances
  has_many :chances, :dependent => :destroy

  has_many :supports

  has_many :supports

  has_one :payment

  has_one :payment, :dependent => :destroy

  has_many :flags, :dependent => :destroy

  scope :with_flag, lambda {|flag, value| joins(:flags).where("flags.name = ? and flags.value_boolean = ?", flag, value)}


  #   # the participations in user_todos:
  has_many :user_wishes, :dependent => :destroy
  has_many :wishes, through: :user_wishes

  has_many :state_users, :dependent => :destroy
  has_many :states, through: :state_users

  #validates_presence_of   :avatar
  validates_integrity_of  :avatar
  validates_processing_of :avatar
  validates :datenschutz, inclusion: [true]

  scope :byids, ->(ids) { where(['users.id IN (?)', ids.split(',')])}
  scope :with_newsletter, lambda { where(newsletter: true) }
  scope :confirmed, lambda { where('confirmed_at is not null') }
  scope :participating, lambda { includes(:chances).where(chances: { :confirmed => true })}
  scope :not_participating, -> { where.not(:id => Chance.where(chances: { :confirmed => true }).select(:user_id).uniq) }
  scope :has_code, lambda { includes(:chances).where.not(chances: { :code => nil })}
  scope :with_crowdbar, lambda { includes(:flags).where(flags: {name: 'hasCrowdbar', value_boolean: true}) }
  scope :without_crowdbar, lambda { includes(:flags).where(flags: {name: 'hasCrowdbar', value_boolean: false}) }
  scope :sign_up_after, ->(date) { where('created_at > ?',date)}
  scope :is_squirrel, lambda { includes(:payment).where(payments: {:active => true}) }
  scope :frst_notification_not_sent, lambda { includes(:payment).where(payments: { :sent_first_notification_at => nil }) }
  scope :last_squirrel_id, ->(last_squirrel_id) { includes(:payment).where(payments: { :id => 0..last_squirrel_id.to_i }) }

  def self.all_newsletter_receipients

  end

end
