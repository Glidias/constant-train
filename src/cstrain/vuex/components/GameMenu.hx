package cstrain.vuex.components;
import cstrain.vuex.game.GameActions;
import cstrain.vuex.game.GameMenuActions;
import cstrain.vuex.store.GameStore;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;
import cstrain.vuex.components.BasicTypes;
import js.Browser;
import js.Lib;
import js.html.ScrollOptions;

/**
 * ...
 * @author Glidias
 */
class GameMenu extends VxComponent<GameStore, GameMenuData, NoneT>
{

	public function new() 
	{
		super();
	}
	
	public static inline var TAG:String = "GameMenu";
	@:action static var action:GameMenuActions;
	
	override public function Data():GameMenuData {
		return { 
			joinKey:"",
			gameOptions:[1],
		}
	}
	
	function loseInputFocus():Void {
	
		Browser.window.scrollTo(0,0);
	}
	
	function beginGame():Void {
		action._newGame(store, { options:{options:this.gameOptions}, store:_vStore });
	}
	
	function joinGame():Void {
		if ( this.joinKey != null && this.joinKey != "") action._joinGame(store, { joinCode:this.joinKey, store:_vStore });
	}
	
	override public function Template():String {
		return '<div class="game-menu">
			<h2>New Game</h2>
			<div class="gametitle">TestGame</div>
			<div class="game-opts">
				<label for="gameoption_1">Length of Race:</label>
				<select id="gameoption_1" v-model.number="gameOptions[0]" class="testgame-opt" v-on:blur="loseInputFocus()">
					<option :value="n" v-for="n in 8">{{n}}</option>
				</select>
			</div>
			<br/>
			<div class="btn-zone">
				<${TouchVUtil.TAG} tag="button" v-on:tap="beginGame()">Begin</${TouchVUtil.TAG}>
			</div>
			<hr/>
			<h2>Join Game</h2>
			<input type="text" v-model="joinKey" v-on:blur="loseInputFocus()"></input>
			<div class="btn-zone">
				<${TouchVUtil.TAG} tag="button" v-on:tap="joinGame()">Connect</${TouchVUtil.TAG}>
			</div>
		</div>
		';
	}
	
}

typedef GameMenuData = {
	var joinKey:String;
	var gameOptions:Array<Int>;
}