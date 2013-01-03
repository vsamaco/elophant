require 'json'
require 'singleton'

module LeagueOfLegends
  class Champions
    include Singleton
    
    attr_reader :champions
    
    def initialize
      load_champions('champions.json')
    end
    
    def get_name(champion_id)
      @champions[champion_id] || nil
    end
    
    def get_id(champion_name)
      @champions.key(champion_name)
    end
    
    private
    def load_champions(file_name)
      fs = File.read(Rails.root.join("lib/league_of_legends/#{file_name}"))
      json = JSON.parse(fs)
      data = json["data"]
      @champions = Hash[data.map { |champion| [champion['id'], champion['name']] }]
    end
  end
end