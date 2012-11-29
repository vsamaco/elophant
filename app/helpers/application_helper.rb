module ApplicationHelper
  def champion_name(id)
    LeagueOfLegends::Champions.instance.get_name(id)
  end
  
  def item_name(id)
    LeagueOfLegends::Items.instance.get_name(id)
  end
end
