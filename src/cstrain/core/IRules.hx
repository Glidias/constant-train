package cstrain.core;
import cstrain.core.Card;
import cstrain.core.GameSettings;
import msignal.Signal.Signal1;

/**
 * Standard ruleset game model interface for The Constant Train 
 * @author Glidias
 */
interface IRules 
{
	//public function isConstant():Bool;
	public var onCardResult(default,never):Signal1<CardResult>;
	
	public function playCard(isSwipeRight:Bool):CardResult;    // executes card play (assumed the topmost card)
	
	public function getTopmostCard():Card; // get current card to be played
	public function getNextCardBelow():Card; 	// get current card underneath current card to be played
	
	function restart(?seed:Int, ?options:Array<Int>):Void;	// restart game
	function getAllCards():Array<Card>;	// reflects play deck along train path of +-/* operations
	function getDeckIndex():Int;	// reflects current play deck index starting from zero
	
	function getPolynomial():Polynomial;  // gets polynomial expression
	
	function getPlayerStats():PlayerStats;
	
	function getGameSettings():GameSettings;
	
	function setScene(scene:IBGTrain):Void;
	

	
	
}