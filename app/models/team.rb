class Team < ActiveRecord::Base
  has_and_belongs_to_many :players
  has_many :matches

  attr_accessor :player_list
  after_save :update_players

  def display_name
    players.map{|p| p.username}.join(" & ")
  end

  def matches
    Match.find(:all, :conditions => "home_team_id =  #{id}") + Match.find(:all, :conditions => "away_team_id =  #{id}")
  end

  def wins
     Match.find(:all, :conditions => "home_team_id =  #{id} AND home_score > away_score").count + Match.find(:all, :conditions => "away_team_id =  #{id} AND away_score > home_score").count
  end

  def losses
    Match.find(:all, :conditions => "home_team_id =  #{id} AND home_score < away_score").count + Match.find(:all, :conditions => "away_team_id =  #{id} AND away_score < home_score").count
  end

  def draws
	Match.find(:all, :conditions => "home_team_id =  #{id} AND home_score = away_score").count + Match.find(:all, :conditions => "away_team_id =  #{id} AND away_score = home_score").count
  end

  def points
    (wins * 3) + (draws * 1)
  end

  private
  def update_players
    #players.delete_all
    selected_players = player_list.nil? ? [] : player_list.keys.collect{|id| Player.find_by_id(id)}
    selected_players.each {|player| self.players << player}
  end
end
