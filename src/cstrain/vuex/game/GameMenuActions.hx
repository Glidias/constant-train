package cstrain.vuex.game;
import cstrain.core.GameSettings;
import cstrain.core.GameSettings.GameOptions;
import cstrain.core.IBGTrain;
import cstrain.core.IRules;
import cstrain.rules.TestGame;
import cstrain.rules.monster.MonsterSpecs;
import cstrain.rules.monster.StartMonsterSpecs;
import cstrain.rules.player.PlayerSpecs;
import cstrain.vuex.components.BasicTypes.GameCreateOptions;
import cstrain.vuex.components.BasicTypes.GameJoinOptions;
import cstrain.vuex.store.GameStore.GameStoreState;
import haxevx.vuex.core.IAction;
import haxevx.vuex.core.IMutator;
import haxevx.vuex.core.IVxContext.IVxContext1;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxBoot;
import haxevx.vuex.native.Vuex;


/**
 * ...
 * @author Glidias
 */
class GameMenuActions implements IAction<GameStoreState, NoneT>	
{

	public function new() 
	{
		
	}
	
	public static var BGTRAIN:IBGTrain;
	
	@:mutator static var mutator:GameMutator;

	function newGame(context:IVxContext1<GameStoreState>, create:GameCreateOptions):Void {
		var rules:IRules = new TestGame();
		rules.setScene(BGTRAIN);
		rules.restart(create.options.seed, create.options.options);
		
		var mod =  new GameModule(rules, BGTRAIN, context.state._savedLevelStats);
		VxBoot.registerModuleWithStore("game", mod, create.store);
		
		mutator._restart(context);
		
	}
	
	function joinGame(context:IVxContext1<GameStoreState>, join:GameJoinOptions):Void {
		var rules:IRules = new TestGame();
		rules.setScene(BGTRAIN);
		rules.restart( GameSettings.getSeedFromUniqueId(join.joinCode), GameSettings.getOptionsFromUniqueId(join.joinCode) );
		
		
		var mod =  new GameModule(rules, BGTRAIN, context.state._savedLevelStats);
		VxBoot.registerModuleWithStore("game", mod, join.store);
		mutator._restart(context);

	}
	
	function quitGame(context:IVxContext1<GameStoreState>, store:Store<Dynamic>):Void {
		GameActions.clearTimer();
		context.state.game._signalUpdate.removeAll();	// need to refactor this to lifecycle..
		context.state.game._gameWorld.end();
		store.unregisterModule("game");
		
		BGTRAIN.resetTo(0);
	}
	
	
	
	function restartNewGame(context:IVxContext1<GameStoreState>, create:GameCreateOptions):Void {
		
		GameActions.clearTimer();
		context.state.game._signalUpdate.removeAll();    // need to refactor this to lifecycle..
		context.state.game._gameWorld.end();
		create.store.unregisterModule("game");
		BGTRAIN.resetTo(0);
		
		var rules:IRules = new TestGame();
		rules.setScene(BGTRAIN);
		rules.restart(create.options.seed, create.options.options);
	
		var mod =  new GameModule(rules, BGTRAIN, context.state._savedLevelStats);
		VxBoot.registerModuleWithStore("game", mod, create.store);
		mutator._restart(context);
		
		
	}
	
}
