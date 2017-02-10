package cstrain.core;
import cstrain.core.Card;

/**
 * Standard ruleset game model interface for The Constant Train 
 * @author Glidias
 */
interface IRules 
{
	//public function isConstant():Bool;
	
	public function playCard(isSwipeRight:Bool):CardResult;    // executes card play (assumed the topmost card)
	
	//  Call the foloowing card getters in sequence (topmost first then nexst card below)
	// get current card to be played
	public function getTopmostCard():Card; 
	// get next card underneath current card to be played (useful for anticipating/triggering any last minute modifications to next card result's display.)
	public function getNextCardBelow():Card; 	
	
	function restart():Void;	// restart game
	function getAllCards():Array<Card>;	// reflects play deck along train path of regular arithmetric/mutating operations
	
	function getPolynomial():Polynomial;  // gets current polynomial expression
}