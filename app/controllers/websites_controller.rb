class WebsitesController < ApplicationController


  def show

    b = request.env['HTTP_USER_AGENT']
  	if b.include?('facebookexternalhit') || b.include?('Twitterbot') # || b.include?('Mozilla')


      if request.fullpath == '/tandem'
        @title = "#bgeMitDir - Die neue Tandemverlosung"
        @text = "MeinBGE verlost jetzt 2 Grundeinkommen an 2 Menschen, die sich kennen. Bilde Tandems mit all den Menschen, denen du Grundeinkommen gönnst und erhaltet ein Jahr lang je 1.000 € monatlich. Bedingungslos."
        @img = 'https://www.mein-grundeinkommen.de/tandemgross.gif'
        render :layout => "preview"
        return
      end


      if params[:mitdir]
  			u = User.find(params[:mitdir])
  			@title = "Ich will #bgeMitDir gewinnen"
  			@text = "MeinBGE verlost dieses Mal gleich 2 Grundeinkommen. Sei du mein Tandem! Wenn es gewinnt, erhalten wir beide ein Jahr lang jeweils 1.000 € monatlich. Bedingungslos."
  			@img = u.avatar.url
	  		render :layout => "preview"
	  		return
	  	end
  	end
  end

end