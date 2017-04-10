package cstrain.vuex.game;
import cstrain.core.IBGTrain;
import cstrain.core.IRules;
import cstrain.rules.world.GameWorld;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VModule;
import haxevx.vuex.native.Vue;
import cstrain.vuex.game.GameState.GameVueData;
import cstrain.h2d.AbstractBGScene;


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
	 var gameWorld:GameWorld;  // static persistant doesn't seem to work for some strange reason..
	
	@:getter public var gameGetters(default,null):GameGetters;

	public function new(rules:IRules, bgTrain:IBGTrain) 
	{
		gameWorld = new GameWorld();
		this.rules = rules;
		this.bgTrain = bgTrain;
		this.state = new GameState(rules);
	}
	
	override public function _InjNative(g:Dynamic) {
		super._InjNative(g);
		this.state._rules = rules;
		this.state._bgTrain = bgTrain;
		this.state._gameWorld = gameWorld;
		
		this.state._signalUpdate = AbstractBGScene.signalUpdate;
		var plainVueData = new GameVueData();
		new Vue({data:plainVueData});  // make it reactive
		this.state.vueData = plainVueData;
		
		gameWorld.commence(bgTrain, plainVueData);
	}
	
}

