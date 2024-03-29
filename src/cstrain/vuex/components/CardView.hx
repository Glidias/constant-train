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
import cstrain.vuex.components.BasicTypes;
import js.Promise;

import js.html.HtmlElement;

/**
 * ...
 * @author Glidias
 */
@:build(haxevx.vuex.core.VCSS.buildModuleStyleFromFile(null, "scss", "mySTYLE") )
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

	override public function Data():CardViewState {
		var storeCards = store.state.game.cards;

		return {
			swipedAlready:false,
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

	override function Deactivated():Void {

		if (myData()._timer2 != null) {
			myData()._timer2.stop();
			myData()._timer2 = null;

		}
		if (myData()._timer != null) {
			myData()._timer.stop();
			myData()._timer = null;
		}
	}



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
		myData()._timer2 = null;
		tickDown();
		startTickDownNow();
	}

	@:watch function watch_delayTimeInSec(val:Float):Void {
			//if (myData()._timer == null) return;
		myData().secondsLeft = Std.int( Math.floor(val) ) + 1;

		if (val > 0) {
			//trace("SETTING VAL:" + val);
			var f:Float = val - Std.int(val);
			if (f > 0) {
			//	trace("TO START");
				myData()._timer2 = Timer.delay( startTickDown, Std.int( f * 1000) );
			}
			else {
				startTickDown();
			}
		}
		else {
			//	trace("Stopping VAL:" + val);
			if (myData()._timer != null) {
				myData()._timer.stop();
				myData()._timer = null;
			}
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
	@:computed function get_penaltiedStrStyle():Dynamic {
		return {
			"color":  store.game.gameGetters.isPenalized ? "#ff0000" : "inherit"
		}
	}

	var curCardIndex(get, never):Int;
	inline function get_curCardIndex():Int {
		return store.game.gameGetters.curCardIndex;
	}

	var totalCards(get, never):Int;
	inline function get_totalCards():Int {
		return store.game.gameGetters.totalCards;
	}

	var gotDelay(get, never):Bool;
	inline function get_gotDelay():Bool
	{
		return store.state.game.delayTimeLeft > 0;
	}


	override public function onThrowOut(e:SwingCardEvent):js.Promise<CardResult> {

		myData().swipedAlready = true;
		return super.onThrowOut(e);
	}

	function getCardForIndex(i:Int):Card {
		var top = store.state.game.topCard;
		var below =  store.state.game.nextCardBelow;
		var gotDelay:Bool = store.state.game.delayTimeLeft != 0 ;
		var topCardMatch:Bool =  this.topCardIndex != i;
		return gotDelay ? null :  topCardMatch ? this.topCardIndex - 1 != i ? null : below  : top;
	}

	function isPolynomialForIndex(i:Int):Bool {
		var card:Card = getCardForIndex(i);

		return card != null ?  card.isPolynomial() && card.varValues.length > 1 : null;
	}



	var penaltyDesc(get, never):String;
	function get_penaltyDesc():String
	{

		return  store.game.gameGetters.simplePenaltyPhrase;

	}

	var showStack(get, never):Bool;
	function get_showStack():Bool {
		return store.game.gameGetters.cardsLeft > 0;
	}

	 function getProjectedIndexOffset(i:Int):Int {
		//this.curCardIndex + i
		var beltAmt:Int = this.beltAmount;
		return i <= this.topCardIndex ? this.topCardIndex - i : beltAmt - i + this.topCardIndex;
	}

	 function getProjectedCardIndex(i:Int):Int {
		var gotPopupX:Bool = !this.store.game.gameGetters.isMainDeckCard;
		var ci:Int = this.curCardIndex ;
		var normalCase:Int = ci + getProjectedIndexOffset(i);

		return gotPopupX ? ci  == i ? -1 : normalCase - 1  :
							normalCase ;
	}
	inline function isVisibleProjected(i:Int):Bool {

		return getProjectedCardIndex(i) <  this.store.game.gameGetters.totalCards;
	}


	var showUniqueID(get, never):Bool;
	function get_showUniqueID():Bool {
		//store.state.game.curCardIndex == 0 && !this.store.game.gameGetters.isMainDeckCard &&
		return  !myData().swipedAlready;
	}

	var uniqueID(get, never):String;
	function get_uniqueID():String {
		return store.state.game.settings.uniqueID;
	}

	@:computed function get_isAtStop():Bool {
		return store.game.gameGetters.isAtStop;
	}

	@:computed function get_isAtStopReady():Bool {
		return store.game.gameGetters.isAtStopReadyToGo;
	}

	@:computed function get_difficultyLevel():Int {
		return store.game.gameGetters.difficultyLevel;
	}

	public static var STYLE = BaseCardView.STYLE;

	override public function Template():String {
		return '
			<div class="${STYLE.cardview}">
				<div class="${STYLE.hudIndicators}">
					<h3>{{ tickStr }} <span :style="penaltiedStrStyle">{{ penaltiedStr }}</span> &nbsp; [Level {{difficultyLevel}}] {{ curCardIndex}} / {{ totalCards}}<span v-show="isAtStop" class="fa fa-train ${mySTYLE.icon} ${mySTYLE.stopIcon}" :class="{ \'${mySTYLE.ready}\':isAtStopReady }"></span></h3>
				</div>

				<h4 style="font-size:9px" v-show="${BuiltVUtil.isProductionStrNot()}">{{ topCardIndex}}</h4>
				<ul class="${STYLE.cardstack}">
					<${CardV.CompName} v-for="(ref, i) in refCards" :card="getCardForIndex(i)" :style="{\'visibility\': isVisibleProjected(i) ? \'visible\' : \'hidden\' }" :class="{\'${CardV.STYLE.polynomial}\':isPolynomialForIndex(i)}" :stack="$$data._stack" :index="i" :key="i">${#if !production"{{ getProjectedCardIndex(i) }}"#else""#end}</${CardV.CompName}>
				</ul>

				<div class="${STYLE.delayPopup}" v-show="gotDelay ">
					<div class="${STYLE.content}">
						<h4 >{{ penaltyDesc }}!</h4>
						<div class="">{{ secondsLeft }}   seconds left.</div>
					</div>
				</div>

				<div v-show="showUniqueID" class="${STYLE.delayPopup} ${STYLE.uniqueid}">
					<div class="${STYLE.content}">
						<h2 class="">{{ uniqueID }}</h2>
						<p>Before your first swipe, challenge friend(s) to join you on the above ID to race them live!</p>
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
	var swipedAlready:Bool;
	@:optional var _timer:Timer;
	@:optional var _timer2:Timer;
}

