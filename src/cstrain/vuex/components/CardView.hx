package cstrain.vuex.components;
import cstrain.vuex.game.GameActions;
import cstrain.vuex.store.GameStore;
import haxe.Timer;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;
import cstrain.core.Card;

/**
 * ...
 * @author Glidias
 */
class CardView extends VxComponent<GameStore, CardViewState, CardViewProps>
{
	
	@:action  static var actions:GameActions;
	
	public function new() 
	{
		super();
	}
	
	function tickDown():Void 
	{
	//	trace("TICK");
		this.secondsLeft--;
	}
	
	override public function Data():CardViewState {
		return {
			secondsLeft:0
		};
	}
	
	var cardCopy(get, never):String;
	function get_cardCopy():String 
	{
		var delayTimeLeft:Int = this.secondsLeft;
		var regularCopy:String =  Card.canOperate(this.currentCard.operator) ?  getCardCopy(this.currentCard) : getCardCopy(this.currentCard) + " :: " + getCardCopy(this.currentCard.virtualRight);
		var penaltyPhrase:String = store.game.gameGetters.simplePenaltyPhrase + ": "+ this.secondsLeft;
	
		if (this.store.state.game.delayTimeLeft > 0) {
			return penaltyPhrase;
		}
		return regularCopy;
	
	}
	
	var delayTimeInSec(get, never):Float;
	function get_delayTimeInSec():Float 
	{
		return store.state.game.delayTimeLeft / 1000;	
	}
	
	function startTickDownNow():Void {
		
		//trace("TO START TICKDOWN");
		_vData._timer = new Timer(1000);
		_vData._timer.run = tickDown;
	}
	
	function startTickDown():Void {
		
		tickDown();
		startTickDownNow();
	}
	
	@:watch function watch_delayTimeInSec(val:Float):Void {
		
		this.secondsLeft = Std.int( Math.floor(val) ) + 1;
		
		if (val > 0) {
			//trace("SETTING VAL:" + val);
			var f:Float = val - Std.int(val);
			if (f > 0) {
			//	trace("TO START");
				Timer.delay( startTickDown, Std.int( f * 1000) );
			}
			else {
				startTickDown();
			}
		}
		else {
		//	trace("Stopping VAL:" + val);
			_vData._timer.stop();
		}
	}
	
	function swipe(isRight:Bool):Void {
		actions._swipe(store, isRight);
	}
	
	
	var tickStr(get, never):String;
	function get_tickStr():String {
		return store.game.gameGetters.swipedCorrectly ? "✓" : "✗";
	}
	
	var penaltiedStr(get, never):String;
	function get_penaltiedStr():String {
		return store.game.gameGetters.isPenalized ? "!" : "...";
	}
	
	var curCardIndex(get, never):Int;
	function get_curCardIndex():Int {
		return store.game.gameGetters.curCardIndex;
	}
	
	var totalCards(get, never):Int;
	function get_totalCards():Int {
		return store.game.gameGetters.totalCards;
	}
	
	var gotDelay(get, never):Bool;
	function get_gotDelay():Bool 
	{
		return store.state.game.delayTimeLeft > 0;
	}

		
	override public function Template():String {
		return '
			<div class="cardview">
				<h3>Swipe {{ tickStr }} {{ penaltiedStr }} &nbsp; {{ curCardIndex+1}} / {{ totalCards}}</h3>
				
				<div class="card" v-if="currentCard">
					{{ cardCopy }} 
					<br/>
					
				</div>
				<div class="btnswipers" v-show="!gotDelay">
					<button v-on:click="swipe(false)">Left</button>
					<button v-on:click="swipe(true)">Right</button>
				</div>
			</div>
		';
	}
	
	
	static  function getCardCopy(card:Card):String {
		return  ( Card.canOperate(card.operator) ?  Card.stringifyOp(card.operator) : "") + ( card.isVar ? "n" : card.value+"" ) ;
	}
	

	
}

typedef CardViewProps = {
	var currentCard:Card;
}

typedef CardViewState = {
	var secondsLeft:Int;
	@:optional var _timer:Timer;
}