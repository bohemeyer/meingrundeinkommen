class Chance < ActiveRecord::Base
	strip_attributes :only => [:first_name, :last_name]

	belongs_to :user

	validates_presence_of :first_name, :last_name, :dob

	validates_uniqueness_of :code, :allow_blank => true, :allow_nil => true

	validate :unique_entry

	validate :no_winner

	validate :validate_birthday

	def unique_entry
		matched_entry = Chance.where(['LOWER(last_name) = LOWER(?) AND LOWER(first_name) = LOWER(?) AND dob = ? AND confirmed = 1', self.last_name, self.first_name, self.dob]).first
		if matched_entry && (matched_entry.id != self.id)
			errors.add(:last_name, 'Jemand mit deinem Namen und deinem Geburtsdatum nimmt bereits teil. Falls dies nicht du bist, kontaktiere bitte micha@mein-grundeinkommen.de - sehr viel wahrscheinlicher ist aber, dass du aus Versehen zwei User-Accounts bei uns hast und bereits mit dem anderen teilnimmst. Oft passiert das, wenn du z.b. eine E-Mail-Adresse mit @gmail.com hast, dich aber mit @googlemail.com eingeloggt hast (oder andersrum).')
			return false
		end
	end

	def no_winner
		if self.user.winner != 0
			errors.add(:last_name, "Du hast bereits einmal Grundeinkommen gewonnen und kannst deshalb nicht erneut teilnehmen.")
		end
	end

	def validate_birthday

	  if !self.dob
	    errors.add(:dob, "Bitte gib bei Tag, Monat und Jahr nur Ziffern, keine Buchstaben, ein.")
	  	return false
	  end

	  if self.is_child && self.dob < DateTime.new(2015,11,5) - 14.years
	      errors.add(:dob, "Du kannst nur für dein Kind teilnehmen, wenn es am Tag des Gewinnspielendes das 14. Lebensjahr noch nicht vollendet hat. Dein Kind ist alt genug und kann eigenständig (mit einem eigenen Profil) am Gewinnspiel teilnehmen.")
	      return false
	  end
	  if !self.is_child && self.dob > DateTime.new(2015,11,5) - 14.years
	      errors.add(:dob, "Du musst 14 Jahre alt sein, um teilnehmen zu können. Ein_e Erziehungsberechtigte_r kann aber für dich am Gewinnspiel teilnehmen indem er oder sie hier unten auf 'Mein Kind hinzufügen' klickt.")
	      return false
	  end
	end

end
