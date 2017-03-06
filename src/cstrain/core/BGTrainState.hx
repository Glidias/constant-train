package cstrain.core;

/**
 * Reflects background state of train movement
 * @author Glidias
 */
enum BGTrainState 
{
	STOPPED;	// completely stopped
	ACCEL(wontSpeed:Bool);	// accelerating (wontSpeed indiciates it won't be able to reach max speed due to stop ahead)
	SPEEDING;	// travelling at peak max speed
	BRAKING(wontSpeed:Bool);	// accelerating (wontSpeed indiciates it wasn't be able to reach max speed due to stop ahead)
}