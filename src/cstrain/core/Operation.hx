package cstrain.core;

/**
 * @author Glidias
 */
enum Operation 
{
	ADD(val:Float, varSuffix:Bool);
	SUBTRACT(val:Float, varSuffix:Bool);
	MULTIPLY(val:Float, varSuffix:Bool);
	DIVIDE(val:Float, varSuffix:Bool);
	DIVIDE_BY_POLYNOMIAL(coefs:Array<Float>);
	EQUAL(val:Float, varSuffix:Bool);
	DERIVATIVE; // keep it simple, just 1st deriative without degree.
}