package cstrain.core;

/**
 * @author Glidias
 */
interface IBGTrain 
{
	// SERVER/CLIENT
	
	// Send 
	function resetTo(index:Int):Void;
	function travelTo(index:Int):Void;
	function stopAt(index:Int):Void; 
	function missStopAt(index:Int):Void; 
	
	// maximum amount of indices the train can move in a single second. Often used in gameplay.
	function setMaxSpeed(maxSpeed:Float):Void;
	
	function setPickupTimespans(accelSpan:Float, brakeSpan:Float):Void;
	
	
	// Server will likely just return any changes to critical values such as: _startIndex/_tweenProgress/_tweenDuration/targetDest/movingState, and clients will reflect changes accordingly in their own update loops.
	// Thus, server need not run any per frame executions per client.
	
	// --------------------------

	// CLIENT ONLY
	
	// Update/Refresh (client side values) 
	function update():Void;	
	
	// cruising speed => "comfortable" moving speed. Currently not used ingame or as part of gameplay.
	function setCruisingSpeed(speed:Float):Void;
	
	function getTimeLeft():Float;
	
	
	// Read (client side values)
	var currentPosition(get, never):Float;
	var movingState(default, never):BGTrainState;
	var targetDest(get, never):Float;

}