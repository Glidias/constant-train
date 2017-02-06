package cstrain.core;
import cstrain.core.Card;

/**
 * Standard ruleset game model interface for The Constant Train 
 * @author Glidias
 */
interface IRules 
{
	//public function isConstant():Bool;
	
	public function playCard(isSwipeRight:Bool):CardResult;
	public function getTopmostCard():Card;
	public function getNextCardBelow():Card;
	
	function restart():Void;
	function getAllCards():Array<Card>;
}