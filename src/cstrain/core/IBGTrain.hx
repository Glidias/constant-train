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
	
	// minimum amount of indices the train can move in a single second. 
	function setCruisingSpeed(speed:Float):Void;
	// maximum amount of indices the train can move in a single second.
	function setMaxSpeed(maxSpeed:Float):Void;
}