require "rubygems"

namespace :testimonials do
  task :insert => :environment do
    desc "insert crowdbar testimonial statements"


    statements = {
      27425 => 'Ich nutze die Crowdbar, weil es einfach ein schöner Gedanke ist, dass man so ganz nebenbei und ohne, dass es mehr kostet, etwas so Tolles mitfinanzieren kann.',
      5735 => 'Das ist fast ein bisschen wie Robin Hood, ausser dass es natürlich viel einfacher ist, einen link zu klicken, als im mittleralterlichen Wald Adlige zu überfallen. ',
      2583 => 'Es tut nicht weh, es kostet nichts aber es hilft einem anderen Menschen das Grundeinkommen zu bekommen. Besser gehts doch nicht.....',
      4661 => 'es ist einfach bequem und läßt einem wenigstens das Gefühl bei einem Amazoneinkauf etwas Gutes getan zu habe',
      442 => 'Ich habe die Crowdbar installiert, weil ich wenig Geld habe und sonst wenig geben kann.',
      3867 => 'mich fasziniert wie man mit einem Klick Gutes tun kann',
      29316 => 'es ist schön unkompliziert.',
      16817 => 'Am Anfang war ich skeptisch, jetzt denke ich die Vorteile überwiegen und WOW! es funktioniert.',
      634 => 'Einfacher kann ich die Idee "mein Grundeinkommen" nicht unterstützt, als die Crowdbar beim Onlinekauf zu nutzen.',
      4339 => 'gut gefühlt als sie letztens das erste mal "gegriffen" hat..',
      5519 => 'Ich mag sie! :)',
      4714 => 'Ich nutze die CrowdBar, weil ich seit Jahren ein absoluter Befürworter des bedingungslosen Grundeinkommens bin und dieses Projekt mitfinanzieren möchte.'
    }

    statements.each do |comment|
      s = Support.where("payment_method = 'crowdbar' and comment is null").sample()
      s.update_attributes(:comment => comment[1], :user_id => comment[0])
    end



  end
end