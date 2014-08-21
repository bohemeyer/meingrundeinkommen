require 'clockwork'
require 'httparty'
require 'debugger'

module Clockwork

  handler do |job|

    response = HTTParty.get('https://www.startnext.de/tycon/modules/crowdfunding/api/v1.1/projects/15645/?client_id=82142814552425')
    json = JSON.parse(response.body)
    current_amount = json["project"]["funding_status"]

    if File.exists?("../public/startnext.json")
      cached_data = File.open("../public/startnext.json") do |file|
        JSON.parse(file.read)
      end
      cached_amount = cached_data["project"]["funding_status"]
    end

    if (defined?(cached_amount) && cached_amount != current_amount) || !defined?(cached_amount)
      File.open("../public/startnext.json", "w+") do |f|
        f.write(json.to_json)
      end
    end

  end

  every(1.minutes, 'ask startnext')

end