package cstrain.vuex.game;
import cstrain.core.IBGTrain;
import cstrain.core.IRules;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VModule;

/**
 * ...
 * @author Glidias
 */
class GameModule extends VModule<GameState, NoneT>
{
	var rules:IRules;

	@:mutator static var mutator:GameMutator;
	@:action static var action:GameActions;
	var bgTrain:IBGTrain;
	
	@:getter public var gameGetters(default,null):GameGetters;

	public function new(rules:IRules, bgTrain:IBGTrain) 
	{
		this.rules = rules;
		rules.restart();
		this.bgTrain = bgTrain;
		this.state = new GameState(rules);
	}
	
	override public function _InjNative(g:Dynamic) {
		super._InjNative(g);
		this.state._rules = rules;
		this.state._bgTrain = bgTrain;
		
	}
	
}
