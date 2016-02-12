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
			errors.add(:last_name, 'Jemand mit deinem Namen und deinem Geburtsdatum nimmt bereits teil. Falls dies nicht du bist, kontaktiere bitte support@mein-grundeinkommen.de - sehr viel wahrscheinlicher ist aber, dass du aus Versehen zwei User-Accounts bei uns hast und bereits mit dem anderen teilnimmst. Oft passiert das, wenn du z.b. eine E-Mail-Adresse mit @gmail.com hast, dich aber mit @googlemail.com eingeloggt hast (oder andersrum).')
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

	  if self.is_child && self.dob < DateTime.now - 14.years
	      errors.add(:dob, "Du kannst nur für dein Kind teilnehmen, wenn es am Tag des Gewinnspielendes das 14. Lebensjahr noch nicht vollendet hat. Dein Kind ist alt genug und kann eigenständig (mit einem eigenen Profil) am Gewinnspiel teilnehmen.")
	      return false
	  end
	  if !self.is_child && self.dob > DateTime.now - 14.years
	      errors.add(:dob, "Du musst 14 Jahre alt sein, um teilnehmen zu können. Ein_e Erziehungsberechtigte_r kann aber für dich am Gewinnspiel teilnehmen indem er oder sie hier unten auf 'Mein Kind hinzufügen' klickt.")
	      return false
	  end
	end

	def generatetandemcodes

		uid = user_id
		tandems = Tandem.where("((inviter_id = #{uid} and inviter_code is null) or (invitee_id = #{uid} and invitee_code is null)) and inviter_id in (select user_id from chances where confirmed=1) and invitee_id in (select user_id from chances where confirmed=1)  and inviter_id != invitee_id and inviter_id is not null and invitee_id is not null and disabled_by is null").limit(100)

		#tandems = Tandem.where("((inviter_id = #{uid} and inviter_code is null) or (invitee_id = #{uid} and invitee_code is null))").limit(100)

        if tandems.count < 7
          code = 1
          tandems.each do |t|
            role = t.inviter_id == uid ? "inviter" : "invitee"
            t.update_attribute("#{role}_code", "#{code}")
            code = code + 1
          end
        else
          i = 0
          (1..4).each do |c1|
            [2,3,4,6,7,9,10,11,12,13,15,16,17,19,20,22,23,24,25,27,28,29,30,32,33,34].each do |c2|
              if tandems[i]
                role = tandems[i].inviter_id == uid ? "inviter" : "invitee"
                tandems[i].update_attribute("#{role}_code", "#{c1}•#{c2}")
                i = i + 1
              end
            end
          end
        end
        return true
	end



end
