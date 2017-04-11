package cstrain.vuex.store;
import cstrain.rules.player.PlayerSpecs;
import cstrain.rules.monster.StartMonsterSpecs;

/**
 * ...
 * @author test
 */
typedef SaveGameData = {
	var LAST_MONSTER_SPECS:StartMonsterSpecs;
	var LAST_PLAYER_SPECS:PlayerSpecs;
}