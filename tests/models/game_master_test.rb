require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require "models/game_master"
require "errors"
class GameMasterTest < Minitest::Test

  def setup
    @game_master = GameMaster.new(GameState.new)
  end

  def test_create_players_raises_error_if_players_have_been_chosen
    @game_master.create_players( ["bob", "alice"] )
    assert_raises(PlayersHaveBeenChosen) {
      @game_master.create_players( ["greg", "bobby"] )
    }
  end

  def test_create_players_raise_error_if_there_are_too_many_players
    assert_raises(TooManyPlayers) { 
      @game_master.create_players( ["bob", "alice", "tim"] ) 
    }
  end

  def test_create_players_adds_players_to_the_game
    @game_master.create_players( ["alice", "bob"] )
    assert_equal 2, @game_master.game_state.players.length
    only_cardinals = @game_master.game_state.players.map do |player|
      player.cardinal_point
    end
    assert_equal ["North", "South"], only_cardinals
  end

  def test_create_player_raises_error_if_one_of_players_names_is_empty
    assert_raises(PlayerDoNotHaveName) {
      @game_master.create_players( ["bob", ""] )
    }
  end

  def test_create_player_raises_error_if_players_names_not_unique
    assert_raises(IdenticalPlayersNames) {
      @game_master.create_players( ["bob", "bob"] )
    }
  end

  def test_assign_players_color
    @game_master.create_players( ["bob", "alice"] )
    @game_master.assign_players_color(@game_master.game_state.players)
    assert_equal "blue", @game_master.game_state.players[0].color
    assert_equal "red", @game_master.game_state.players[1].color
  end

  def test_if_attribute_race
    @game_master.create_players( ["bob", "alice"] )
    @player = @game_master.game_state.players[0]
    @race_1 = Race.new("humans", 15)
    @game_master.attribute_race(@player, @race_1)
    assert_equal "humans", @player.race.first.name
  end

  def test_if_check_if_players_names_method_is_valid
    assert @game_master.check_if_players_names_are_valid?("franck alex")
    refute @game_master.check_if_players_names_are_valid?("bobby")
  end

end
