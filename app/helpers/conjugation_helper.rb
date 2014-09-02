# encoding: UTF-8
module ConjugationHelper


# GERMAN RULEZ

  BEGINNING_FIRST_PERSON_REGEXP = /^(mich|mir)\s/i
  THIRD_PERSON = 'sich'
  PRAEPOS = %w{ bei aus an hinter von mit für zu }


    def has_name_prefix?(name)
      return !name.downcase.match(/^mich\s.*$/).nil? || !name.downcase.match(/^mir\s.*$/).nil?
    end


    #refactore for other persons
    def without_person(todo, person = :me, gender = :male)
      correct_todo_sentence(todo, person, false, false, gender)
    end

    def has_prefix?(todo)
      !first_person_prefix(todo).nil?
    end

    def third_person_prefix(todo)
      has_prefix?(todo) ? THIRD_PERSON : ""
    end

    def first_person_prefix(todo)
      result = todo.name.match(BEGINNING_FIRST_PERSON_REGEXP)
      result ? result[1] : nil
    end

    # ich will        -- :me
    # willst Du       -- :you
    # willst Du gemiensam mit ihm/ihr?  -- :you_too
    # [name] will     -- :he --> can have a list of names = []
    # Alle Leute, die -- :they
    # TODO: ENGLISH VERSION
    def conjugate_sentence(text, person = :me, comma=true, prefix = true, gender = :male, add_space = false)
      return "" if !text
      text.gsub!(BEGINNING_FIRST_PERSON_REGEXP," ") if !prefix
      text.strip if !prefix
      text.gsub! /^((dass|daß).*)$/i do |x| ", "+$1 end if comma #comma if starts with dass/daß

       add_space = false if text.match(/^,\s[dass|daß].*$/i)


      if person == :you || person == :you_too

        text = text.gsub(/^mein\s/i, "dein ").gsub(/\smein\s/i, " dein ").gsub(/\smein$/i, " dein") #replaces mein with dein
        text = text.gsub(/^meine\s/i, "deine ").gsub(/\smeine\s/i, " deine ").gsub(/\smeine$/i, " deine") #replaces meine with deine
        text = text.gsub(/^meinen\s/i, "deinen ").gsub(/\smeinen\s/i, " deinen ").gsub(/\smeinen$/i, " deinen") #replaces meinen with deinen
        text = text.gsub(/^meinem\s/i, "deinen ").gsub(/\smeinem\s/i, " deinem ").gsub(/\smeinem$/i, " deinem") #replaces meinen with deinen

        if person == :you
          insertion = "auch "
        elsif person == :you_too
          insertion = "gemeinsam mit " + ((gender==:male) ? "ihm " : "ihr ")
        end

        text = text.gsub(/^mich\s/i, "dich #{insertion}").gsub(/\smich\s/i, " dich ").gsub(/\smich$/i, " dich") #replaces mich with dich
        text = text.gsub(/^mir\s/i, "dir #{insertion}").gsub(/\smir\s/i, " dir ").gsub(/\smir$/i, " dir") #replaces mir with dir

        if text.match(/^dich\s.*$/i).nil? && text.match(/^dir\s.*$/i).nil?
            text = insertion + text + "?"
        else
         text = text + "?"
        end

      elsif person == :he

        pronoun = gender == :male ? "sein" : "ihr"
        text = text.gsub(/^mein\s/i, "#{pronoun} ").gsub(/\smein\s/i, " #{pronoun} ").gsub(/\smein$/i, " #{pronoun}") #replaces mein with sein/ihr
        pronoun = gender == :male ? "seine" : "ihre"
        text = text.gsub(/^meine\s/i, "#{pronoun} ").gsub(/\smeine\s/i, " #{pronoun} ").gsub(/\smeine$/i, " #{pronoun}") #replaces meine with seine/ihre
        pronoun = gender == :male ? "seinen" : "ihren"
        text = text.gsub(/^meinen\s/i, "#{pronoun} ").gsub(/\smeinen\s/i, " #{pronoun} ").gsub(/\smeinen$/i, " #{pronoun}") #replaces meinen with seinen/ihren
        pronoun = gender == :male ? "seinem" : "ihrem"
        text = text.gsub(/^meinem\s/i, "#{pronoun} ").gsub(/\smeinem\s/i, " #{pronoun} ").gsub(/\smeinem$/i, " #{pronoun}") #replaces meinem with seinem/ihrem
        pronoun = gender == :male ? "seiner" : "ihrer"
        text = text.gsub(/^meiner\s/i, "#{pronoun} ").gsub(/\smeiner\s/i, " #{pronoun} ").gsub(/\smeiner$/i, " #{pronoun}") #replaces meiner with seiner/ihrer
        pronoun = gender == :male ? "seines" : "ihres"
        text = text.gsub(/^meines\s/i, "#{pronoun} ").gsub(/\smeines\s/i, " #{pronoun} ").gsub(/\smeines$/i, " #{pronoun}") #replaces meines with seines/ihres

        pronoun = gender == :male ? "ihm" : "ihr"
        text = text.gsub(/^(dass|daß)\smir\s/i, "dass #{pronoun} ")
        text = text.gsub(/^,\s(dass|daß)\smir\s/i, ", dass #{pronoun} ")
        pronoun = gender == :male ? "ihn" : "sie"
        text = text.gsub(/^(dass|daß)\smich\s/i, "dass #{pronoun} ")
        text = text.gsub(/^,\s(dass|daß)\smich\s/i, ", dass #{pronoun} ")

        # prepos handling

        text = text.gsub(/(#{PRAEPOS.join('|')})\s+(mir|mich)\s/i, '\1 sich ') #replaces first mich with sich
        text = text.gsub(/^mir\s/i, " ") #replaces first mir with sich


        text = text.gsub(/^mich\s/i, " ") #replaces first mich with sich
        text = text.gsub(/^mir\s/i, " ") #replaces first mir with sich

        pronoun = gender == :male ? "ihn" : "sie"
        text = text.gsub(/\smich\s/i, " #{pronoun} ").gsub(/\smich$/i, " #{pronoun}") #replaces other mich with ihn/sie
        pronoun = gender == :male ? "ihm" : "ihr"
        text = text.gsub(/\smir\s/i, " #{pronoun} ").gsub(/\smir$/i, " #{pronoun}") #replaces other mir with ihm/ihr



        text = has_name_prefix?(text) ? " sich " + text : text if prefix
        text = !has_name_prefix?(text) ? " sich " + text : text if prefix

      elsif person == :they || person == :they2

        text = text.gsub(/^mein\s/i, "ihr ").gsub(/\smein\s/i, " ihr ").gsub(/\smein$/i, " ihr") #replaces mein with ihr
        text = text.gsub(/^meine\s/i, "ihre ").gsub(/\smeine\s/i, " ihre ").gsub(/\smeine$/i, " ihre") #replaces meine with ihre
        text = text.gsub(/^meinen\s/i, "ihren ").gsub(/\smeinen\s/i, " ihren ").gsub(/\smeinen$/i, " ihren") #replaces meinen with ihren
        text = text.gsub(/^meinem\s/i, "ihrem ").gsub(/\smeinem\s/i, " ihrem ").gsub(/\smeinem$/i, " ihrem") #replaces meinen with ihren

        text = text.gsub(/(#{PRAEPOS.join('|')})\s+(mir|mich)\s/i, '\1 sich ') #replaces first mich with sich

        text = text.gsub(/^(dass|daß)\smir\s/i, "dass ihnen ")
        text = text.gsub(/^,\s(dass|daß)\smir\s/i, ", dass ihnen ")
        text = text.gsub(/^(dass|daß)\smich\s/i, "dass sie ")
        text = text.gsub(/^,\s(dass|daß)\smich\s/i, ", dass sie ")

        text = text.gsub(/^mich\s/i, "sich ") #replaces first mich with sich
        text = text.gsub(/^mir\s/i, "sich ") #replaces first mir with sich

        text = text.gsub(/\smich\s/i, " sie ").gsub(/\smich$/i, " sie") #replaces other mich with sie (job, der sie befriedigt)
        text = text.gsub(/\smir\s/i, " ihnen ").gsub(/\smir$/i, " ihnen") #replaces other mir with ihnen (job, der ihnen spaß macht)

        # if person == :they
        #   if text.match(/^,\s[dass|daß].*$/i).nil?
        #     text = text + " wollen"
        #   else
        #     text = "wollen" + text
        #   end
        # end
      end
      text = " " + text if add_space
      text
    end

# ENGLISH RULEZ

  #persons:
  #  :me
  #  :tagcloud
  #  :question
  #  :he
  #  :they
  def correct_english_todo(todo, person=:me, gender=:male)
    text = todo.name
    if person == :tagcloud
      text.gsub!(/^to\s/i, "")
    elsif person == :question
      text.gsub!(/(\s+|^)(me)(\s+|$)/i, " yourself ").strip!
      text.gsub!(/(\s+|^)(my)(\s+|$)/i, " your ").strip!
      text.gsub!(/(\s+|^)(i)(\s+|$)/i, " you ").strip!
    elsif person == :he
      gender_pronoun = gender == :male ? "himself" : "herself"
      text.gsub!(/(\s+|^)(me)(\s+|$)/i, " #{gender_pronoun} ").strip!
      gender_pronoun = gender == :male ? "his" : "her"
      text.gsub!(/(\s+|^)(my)(\s+|$)/i, " #{gender_pronoun} ").strip!
      gender_pronoun = gender == :male ? "he" : "she"
      text.gsub!(/(\s+|^)(i)(\s+|$)/i, " #{gender_pronoun} ").strip!
    elsif person == :they
      text.gsub!(/(\s+|^)(me)(\s+|$)/i, " themselves ").strip!
      text.gsub!(/(\s+|^)(my)(\s+|$)/i, " their ").strip!
      text.gsub!(/(\s+|^)(i)(\s+|$)/i, " they ").strip!
    end
  end
end