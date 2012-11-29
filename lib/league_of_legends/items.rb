require 'json'
require 'singleton'

module LeagueOfLegends
  class Items
    include Singleton
    
    attr_accessor :items
    
    def initialize(file_name='items.json')
      load_items(file_name)
    end
    
    def get_name(item_id)
      @items[item_id] || nil
    end
    
    def get_id(item_name)
      @items.key(item_name) || nil
    end
    
    private
    def load_items(file_name)
      fs = File.read(Rails.root.join("lib/league_of_legends/#{file_name}"))
      json = JSON.parse(fs)
      @items = Hash[json.map { |item| [item['id'].to_i, item['name']] }]
    end
  end
end