class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :newsletter, :chances, :has_crowdbar, :wishes, :states, :confirmed_at, :admin, :flags, :payment, :tandems, :initial_wishes #, :crowdcards

  def email
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.email
    else
      ''
    end
  end

  def initial_wishes
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.initial_wishes
    else
      ''
    end
  end

  def confirmed_at
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.confirmed_at
    else
      ''
    end
  end

  def has_crowdbar
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.has_crowdbar
    else
      ''
    end
  end

  def chances
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.chances.order(:is_child => :asc)
    else
      r = []
      object.chances.each do |c|
        r << c.slice(:code,:code2,:is_child,:crowdbar_verified,:affiliate)
      end
      r
    end
  end

  def newsletter
    if object == current_user
      object.newsletter
    else
      ''
    end
  end

  def admin
    if current_user && object == current_user && current_user.admin?
      true
    else
      false
    end
  end

  # def crowdcards
  #   if (current_user && object == current_user) || (current_user && current_user.admin?)
  #     object.crowdcards if object.crowdcards
  #   else
  #     ''
  #   end
  # end

  def states
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.states
    else
      object.states.where('state_users.visibility' => true)
    end
  end

  def flags
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      r = {}
      object.flags.each do |flag|
        r[flag.name] = flag.display
      end
      r
    else
      ''
    end
  end

  def payment
    if (current_user && object == current_user) || (current_user && current_user.admin?)
      object.payment
    else
      object.payment ? object.payment.active : false
    end
  end


  def tandems

      r = []
      if !object.tandems.nil?
        object.tandems.each do |c|

          if (current_user && object == current_user) || (current_user && current_user.admin?)
            t = {:id => c.id, :inviter_grudges_invitee_for => c.inviter_grudges_invitee_for, :invitee_grudges_inviter_for => c.invitee_grudges_inviter_for, :disabled_by => c.disabled_by, :invitation_type => c.invitation_type, :inviter_id => c.inviter_id, :invitee_id => c.invitee_id, :invitee_name => c.invitee_name, :invitee_email => c.invitee_email, :invitation_accepted_at => c.invitation_accepted_at, :invitee_participates => c.invitee_participates, :inviter_code => c.inviter_code, :invitee_code => c.invitee_code}
          else
            t = {:id => c.id, :inviter_grudges_invitee_for => c.inviter_grudges_invitee_for, :invitee_grudges_inviter_for => c.invitee_grudges_inviter_for, :inviter_id => c.inviter_id, :invitee_id => c.invitee_id, :invitee_name => c.invitee_name, :invitation_accepted_at => c.invitation_accepted_at, :invitee_participates => c.invitee_participates, :inviter_code => c.inviter_code, :invitee_code => c.invitee_code}
          end

          if object.id == c.inviter_id && c.invitee_id
            t[:grudge] = t[:inviter_grudges_invitee_for]
            u = User.find_by_id(c.invitee_id)
            unless u.nil?
              t[:details] = { :name => u.name, :avatar => u.avatar, :code => t[:inviter_code] }
            end
          else
            t[:grudge] = t[:inviter_grudges_invitee_for]
            if object.id == c.inviter_id && t[:invitee_name] && t[:invitee_name] != ""
              t[:details] = { :name => t[:invitee_name], :avatar => nil }
              else
                if object.id == c.inviter_id && t[:invitee_email]
                  t[:details] = { :name => t[:invitee_email], :avatar => nil }
                end
            end
          end
          if object.id == c.invitee_id && c.inviter_id
            t[:grudge] = t[:invitee_grudges_inviter_for]
            u = User.find_by_id(c.inviter_id)
            unless u.nil?
              t[:details] = { :name => u.name, :avatar => u.avatar, :code => t[:invitee_code] }
            end
          end

          r << t
        end
      end
      r
  end

end
