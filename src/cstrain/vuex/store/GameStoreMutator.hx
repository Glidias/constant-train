package cstrain.vuex.store;
import cstrain.vuex.store.GameStore.GameStoreState;
import cstrain.vuex.store.Payloads.SaveGameData;
import haxevx.vuex.core.IMutator;

/**
 * ...
 * @author Glidias
 */
class GameStoreMutator implements IMutator<GameStoreState>
{

	function saveGameForNextLevel(state:GameStoreState,  saveGameData:SaveGameData):Void {
		
		if (saveGameData.LAST_MONSTER_SPECS != null) {
			saveGameData.LAST_MONSTER_SPECS.dummyAddDifficulty();
		}
		state.saveLevel(saveGameData.LAST_PLAYER_SPECS, saveGameData.LAST_MONSTER_SPECS);
	}
	
}