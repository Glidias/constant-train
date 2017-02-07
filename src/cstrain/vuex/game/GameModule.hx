package cstrain.vuex.game;
import cstrain.core.IRules;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VModule;
import haxevx.vuex.core.VxStore;

/**
 * ...
 * @author Glidias
 */
class GameModule extends VModule<GameState, NoneT>
{
	var rules:IRules;

	@:mutator static var mutator:GameMutator;
	@:action static var action:GameActions;
	
	@:getter public var gameGetters(default,null):GameGetters;

	public function new(rules:IRules) 
	{
		this.rules = rules;
		this.state = new GameState(rules);
	}
	
	override public function _InjNative(g:Dynamic) {
		super._InjNative(g);
		this.state._rules = rules;
	
		
	}
	
}
