class Chance < ActiveRecord::Base
	strip_attributes :only => [:first_name, :last_name]

	belongs_to :user

	validates :confirmed_publication, inclusion: [true]

	validates_presence_of :first_name, :last_name, :dob

	validates_uniqueness_of :code, :allow_blank => true, :allow_nil => true

	validate :unique_entry

	validate :validate_birthday

	def unique_entry
		matched_entry = Chance.where(['LOWER(last_name) = LOWER(?) AND LOWER(first_name) = LOWER(?) AND dob = ?', self.last_name, self.first_name, self.dob]).first
		if matched_entry && (matched_entry.id != self.id)
			errors.add(:last_name, 'Jemand mit deinem Namen und deinem Geburtsdatum nimmt bereits teil. Falls dies nicht du bist, kontaktiere bitte micha@mein-grundeinkommen.de')
			return false
		end
	end

	def validate_birthday

	  if !self.dob
	    errors.add(:dob, "Bitte gib bei Tag, Monat und Jahr nur Ziffern, keine Buchstaben, ein.")
	  	return false
	  end

	  if self.is_child && self.dob < DateTime.new(2015,03,19) - 18.years
	      errors.add(:dob, "Du kannst nur für dein Kind teilnehmen, wenn es am Tag des Gewinnspielendes das 18. Lebensjahr noch nicht vollendet hat. Dein Kind ist alt genug und kann eigenständig (mit einem eigenen Profil) am Gewinnspiel teilnehmen.")
	      return false
	  end
	  if !self.is_child && self.dob > DateTime.new(2015,03,19) - 18.years
	      errors.add(:dob, "Du musst 18 Jahre alt sein, um teilnehmen zu können. Ein_e Erziehungsberechtigte_r kann aber für dich am Gewinnspiel teilnehmen indem er oder sie hier unten auf 'Mein Kind hinzufügen' klickt.")
	      return false
	  end
	end

end
