package cstrain.core;

/**
 * @author Glidias
 */
interface IBGTrain 
{
	function resetTo(index:Int):Void;
	function travelTo(index:Int):Void;
	function stopAt(index:Int):Void; 
	function missStopAt(index:Int):Void; 
	
	// cruising speed => "comfortable" moving speed. May not be used ingame or as part of gameplay.
	function setCruisingSpeed(speed:Float):Void;
	// maximum amount of indices the train can move in a single second. Often used in gameplay.
	function setMaxSpeed(maxSpeed:Float):Void;
}