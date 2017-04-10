package cstrain.rules.components;
import msignal.Signal;
import msignal.Signal.Signal2;

/**
 * ...
 * @author Glidias
 */
class Health
{
	public var value:Float = 100;
	public var signalDamaged(default, never):Signal2<Float,Float> = new Signal2<Float,Float>();
	
	public function damage(inflicted:Float):Void {
		value -= inflicted;
		signalDamaged.dispatch(inflicted, value);
	}

	public function new() 
	{
		
	}
	
}

