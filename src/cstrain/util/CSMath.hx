package cstrain.util;

/**
 * ...
 * @author Glidias
 */
class CSMath
{

	
	public static inline function lerp(n0:Float, n1:Float, p:Float):Float
	{
		return n0 * (1 - p) + n1 * p;
	}


	public static inline  function rnd(min:Float, max:Float):Float
	{
		return min + Math.random() * (max - min);
		//  return lerp(min, max, Math.random());
	}
	

	
}
