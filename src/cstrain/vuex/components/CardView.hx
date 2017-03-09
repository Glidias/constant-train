package cstrain.vuex.components;
import cstrain.core.CardResult;
import cstrain.core.Penalty;
import cstrain.core.PenaltyDesc;
import cstrain.core.Polynomial;
import cstrain.vuex.components.BasicTypes;
import cstrain.vuex.components.CardV.CardProps;
import cstrain.vuex.components.GameView;
import cstrain.vuex.game.GameActions;
import cstrain.vuex.game.GameMutator;
import cstrain.vuex.store.GameStore;
import gajus.swing.Swing;
import haxe.Timer;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.core.VxComponent;
import cstrain.core.Card;
import js.Promise;

import js.html.HtmlElement;

/**
 * ...
 * @author Glidias
 */
class CardView extends BaseCardView //<GameStore, CardViewState, CardViewProps>
{
	
	@:action  static var actions:GameActions;
	
	public function new() 
	{
		super();
	}
	
	inline function myData():CardViewState {
		return untyped _vData;
	}
	
	function tickDown():Void 
	{
	//	trace("TICK");
		myData().secondsLeft--;
	}
	
	// Start swing
	
	
	override function onThrowOut(e:SwingCardEvent):Promise<CardResult> {
	
		var promise = super.onThrowOut(e);
		var datam = myData();
		
		promise.then( function(cardResult) {		// sanity check
			
			switch(cardResult) {
				case CardResult.GUESS_CONSTANT(_, _):
					
					e.target.setAttribute("progressing", "1");
					datam.nextBeltCardIndex+=1;
					
					
				case CardResult.PENALIZE({desc:(PenaltyDesc.LOST_IN_TRANSIT | PenaltyDesc.MISSED_STOP | PenaltyDesc.WRONG_CONSTANT)}):
						
						e.target.setAttribute("progressing", "1");
					
						datam.nextBeltCardIndex+=1;
				case CardResult.OK(progress) :
					if (progress > 0) {
						
							e.target.setAttribute("progressing", "1");
						datam.nextBeltCardIndex+=progress;
					}
					else {
						//trace("No progress:" + cardResult);	
						e.target.setAttribute("progressing", "");
					}
				default:
					//trace("No progress:" + cardResult);	
					e.target.setAttribute("progressing", "");
				
					
			}
		
		});
		
		return promise;

	}

	
	override function onThrowOutEnd(e:SwingCardEvent):Void
	{
		
		var index:Int =  Std.parseInt( e.target.getAttribute( "index")   );
		if ( noMoreCardsToRegen() ) {
			//trace("No more visible");
			
			return;
		}
		
		if (e.target.getAttribute("progressing") == "1" ) {
			myData().respawnCount++;
			
		}
		super.onThrowOutEnd(e);
		
	
		
		/*
		var index:Int =  Std.parseInt( e.target.getAttribute( "index")   );
		this._vData.refCards[index].card =  store.state.game.cards[this.nextBeltCardIndex];
		*/

	}
	
	function onThrowInEnd(e:SwingCardEvent):Void
	{

	}
	
	
	override public function Created():Void {
		
		super.Created();
		_vData._stack.on("throwinend", onThrowInEnd);

		
	}
	
	override public function Data():CardViewState {
		var storeCards = store.state.game.cards;
		
		return {
			topCardIndex:BELT_AMOUNT-1,
			secondsLeft:0,
			respawnCount:0,
			nextBeltCardIndex:BELT_AMOUNT,
			beltAmount:BELT_AMOUNT,
			refCards: BaseCardView.getEmptyBelt(BELT_AMOUNT)
		};
	}
	/*
	 [
				{card:storeCards[6]},{card:storeCards[5]},{card:storeCards[4]},{card:storeCards[3]},{card:storeCards[2]},{card:storeCards[1]},{card:storeCards[0]}
			]
			*/
	
	static inline var BELT_AMOUNT:Int = 7;


	
	var delayTimeInSec(get, never):Float;
	function get_delayTimeInSec():Float 
	{
		return store.state.game.delayTimeLeft / 1000;	
	}
	
	function startTickDownNow():Void {
		
		//trace("TO START TICKDOWN");
		myData()._timer = new Timer(1000);
		myData()._timer.run = tickDown;
		
	}
	
	function startTickDown():Void {
		
		tickDown();
		startTickDownNow();
	}
	
	@:watch function watch_delayTimeInSec(val:Float):Void {
		
		myData().secondsLeft = Std.int( Math.floor(val) ) + 1;
		
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
			myData()._timer.stop();
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
	

	
				
	function getCardForIndex(i:Int):Card {
		var top = store.state.game.topCard;
		var below =  store.state.game.nextCardBelow;
		var gotDelay:Bool = store.state.game.delayTimeLeft != 0 ;
		var topCardMatch:Bool =  this.topCardIndex != i;
		return gotDelay ? null :  topCardMatch ? this.topCardIndex - 1 != i ? null : below  : top;
	}
	
	function noMoreCardsToRegen():Bool {
		
		return totalCards - myData().respawnCount < BELT_AMOUNT;
	}
		
	
	var penaltyDesc(get, never):String;
	function get_penaltyDesc():String 
	{

		return  store.game.gameGetters.simplePenaltyPhrase;
	
	}
	
	
	override public function Template():String {
		return '
			<div class="cardview">
				<div class="hud-indicators">
					<h3>{{ tickStr }} {{ penaltiedStr }} &nbsp; {{ curCardIndex}} / {{ totalCards}}</h3>
				</div>
				
				<h4>{{ topCardIndex}}</h4>
				<ul class="cardstack">
					<${BaseCardView.Comp_Card} v-for="(ref, i) in refCards" :card="getCardForIndex(i)" :stack="$$data._stack" :index="i" :key="i">{{i}}</${BaseCardView.Comp_Card}>
				</ul>
				
				<div class="delay-popup" v-show="gotDelay">
					<div class="content">
						<h4 >{{ penaltyDesc }}!</h4>
						<div class="indicator">{{ secondsLeft }}   seconds left.</div>
					</div>
				</div>
			</div>
		';
	}
	

	
	
	

	
}

typedef CardViewState = {
	> SwingStackData,
	var secondsLeft:Int;
	var respawnCount:Int;
	var nextBeltCardIndex:Int;
	@:optional var _timer:Timer;
}

