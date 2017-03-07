package cstrain.vuex.components;
import cstrain.core.Polynomial;
import cstrain.vuex.components.CardV.CardProps;
import cstrain.vuex.components.CardView.RefCard;
import cstrain.vuex.components.GameView;
import cstrain.vuex.game.GameActions;
import cstrain.vuex.store.GameStore;
import gajus.swing.Swing;
import haxe.Timer;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.core.VxComponent;
import cstrain.core.Card;
import js.html.HtmlElement;

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
	
	// Start swing
	
	override public function Created():Void {
		
		_vData._stack = Swing.Stack({
			throwOutConfidence:confidenceHandler
			,			  maxRotation: 30,
			//maxThrowOutDistance: 400,
			//minThrowOutDistance: 400,
			
		});
		_vData._stack.on("throw", onThrow);
		_vData._stack.on("throwoutend", onThrowOutEnd);
		_vData._stack.on("throwinend", onThrowInEnd);
		
		
	
		
	}
	override public function Mounted():Void {
		
		for (vu in _vChildren) {
			vu._vOn("clickTest", clickTestHandler);
		}
	}
	
	function clickTestHandler(index:Int):Void {
	//	trace("CLICK test");
		refCards[index].card = new Card(Card.OPERATOR_SUBTRACT, Std.int(Math.random() * 10) );
	
	}
	
	function onThrow(e:SwingCardEvent):Void {
		if (e.direction == SwingCard.DIRECTION_UP || e.direction == SwingCard.DIRECTION_DOWN ) {
			trace("Capture up and down");
		}
		
	}
	
	
	function confidenceHandler(xOffset:Float, yOffset:Float, element:HtmlElement):Float {
		 var xConfidence = Math.min(Math.abs(xOffset) / element.offsetWidth, 1);
		var yConfidence = Math.min(Math.abs(yOffset) / element.offsetHeight, 1);

		return Math.min(1, Math.max(xConfidence*2, yConfidence*2) );
	}
	
	function onThrowOutEnd(e:SwingCardEvent):Void
	{

		//this.stack = 
		var el:HtmlElement = e.target;
		var par = el.parentNode;
		par.removeChild(el);
	
		
	
		par.insertBefore(el, par.firstChild);
		var card = _vData._stack.getCard(el);
		card.throwIn(0, 0);

	}
	
	function onThrowInEnd(e:SwingCardEvent):Void
	{

		trace("RETURN BACK");
	}
	
	// End swing impl
	
	override public function Data():CardViewState {
		return {
			secondsLeft:0,
			refCards: [
				{card:new Card(Card.OPERATOR_ADD, 1)},{card:null},{card:null},{card:null},{card:null},{card:null},{card:null}
			]
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
	
	static inline var Comp_Card:String = "CardV";
	override public function Components():Dynamic<VComponent<Dynamic,Dynamic>>  {
		return [
			Comp_Card => new CardV()
		];
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
				<ul class="cardstack">
					<${Comp_Card} v-for="(ref, i) in refCards" :card="ref.card" :stack="$$data._stack" :index="i" :key="i">{{i}}</${Comp_Card}>
				</ul>
			</div>
		';
	}
	
	
	public static  function getCardCopy(card:Card):String {
		var isPolynomialOfVars:Bool =  card.isPolynomial();  // required to factor out condition for reactivity!
	
		var cardIsVar:Bool = card.isVar;
		return  ( Card.canOperate(card.operator) ?  Card.stringifyOp(card.operator) : "") + ( isPolynomialOfVars ?  "("+Polynomial.PrintOut(card.getPolynomial(), "n", true)+")" :  ( card.isVar ? "n" : card.value+"" )) ;
	}
	

	
}

typedef CardViewProps = {
	var currentCard:Card;
}

typedef CardViewState = {
	var secondsLeft:Int;
	var refCards:Array<RefCard>;
	@:optional var _stack:SwingStack;
	@:optional var _timer:Timer;
}

typedef RefCard = {
	@:optional  var card:Card;
}